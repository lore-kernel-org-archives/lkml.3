Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3FDVGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:06:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59652 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FDVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:06:43 -0400
Date: Tue, 4 Jun 2013 22:06:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
 proc_task_readdir() paths
Message-ID: <20130604210633.GC13110@ZenIV.linux.org.uk>
References: <20130603190705.GA11517@redhat.com>
 <877giarg81.fsf@xmission.com>
 <20130604171435.GA20416@redhat.com>
 <20130604173917.GB13110@ZenIV.linux.org.uk>
 <20130604195700.GA31933@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604195700.GA31933@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 09:57:00PM +0200, Oleg Nesterov wrote:
> Will do... but so far I am confused.
> 
> I do not see how they could race (I mean /proc/pid/task only). OK, OK,
> the usage of ->f_pos in sys_getdents() looks "obviously wrong", but this
> is another story? And "put f_pos in a local variable" can't help.

For one thing, a bunch of directories use generic_file_llseek(), which
does *not* use ->i_mutex.  For another, there's a very unpleasant problem
with read(2) (failing) attempt racing with ->f_pos modifications in
->readdir().  Take a look at sys_read() and note that it is done with no
serialization at all (not in the top level, that is) and that it puts the
(unmodified by generic_read_dir()) value of pos back into file->f_pos as
soon as vfs_read() passes -EISDIR (returned by generic_read_dir()) back to
sys_read().

I.e. ->f_pos is silently reset back to the value it used to have on the
entry to read(2).  Despite foo_readdir() assumptions that it won't be
changed behind its back.

Reset itself wouldn't be a problem - if several threads mess with read()
on the same opened file in parallel, you are not promised anything good
about the resulting IO pointer position.  The same applies here.  However,
many ->readdir() instances use file->f_pos as a variable they can use for
internal needs and _that_ leads to very unpleasant races.

The sane solution is to do what ->read()/->write()/etc. are doing - pass
an address of local copy of ->f_pos, so they are able to use it without
worrying about concurrent modifications of that value.  That obviously
solves all problems with generic_file_lseek(), etc., as well as this
sys_read() shite.
