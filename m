Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaDYVVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:21:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaDYVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:21:40 -0400
Date: Fri, 25 Apr 2014 22:21:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
Message-ID: <20140425212128.GB18016@ZenIV.linux.org.uk>
References: <535A5C78.1070901@samsung.com>
 <535A75C1.3050901@samsung.com>
 <20140425182310.GA9128@redhat.com>
 <87sip15iy5.fsf@x220.int.ebiederm.org>
 <20140425192543.GA11908@redhat.com>
 <878uqt42q7.fsf@x220.int.ebiederm.org>
 <20140425200156.GA13727@redhat.com>
 <CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
 <874n1h16le.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n1h16le.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:45:17PM -0700, Eric W. Biederman wrote:

> IMA-appraisal is fundamentally broken because I can take a mandatory
> file lock and prevent IMA-apprasial.
> 
> Using kernel_read is what allows this.
> 
> > Isn't it a clear motivating case???
> 
> kernel_read is not appropriate for IMA use.  The rest of this is just
> the messenger.
> 
> IMA needs to use a cousin of kernel_read that operates at a lower level
> than vfs_read.  A function that all of the permission checks and the
> fsnotify work.

It's worse than that, actually ;-/  IMA hooks in __fput() have interesting
interplay with revoke-related stuff as well.  Another very messy thing in
the same area is that it actually does ->read() from under ->i_mutex, leading
to all kinds of interesting locking issues...

I doubt that your "let's open-code vfs_read() guts" would be a good idea;
if nothing else, it might make more sense to make rw_verify_area() skip
the mandlock and security theatre when called in such situation.

What a mess... ;-/
