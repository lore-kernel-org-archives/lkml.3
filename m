Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaAXMYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:24:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaAXMYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:24:11 -0500
Date: Fri, 24 Jan 2014 12:24:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: fix locking bug in __dentry_path()
Message-ID: <20140124122409.GT10323@ZenIV.linux.org.uk>
References: <1390558886-4152-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390558886-4152-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 11:21:26AM +0100, Denys Vlasenko wrote:
> If given buffer size is zero, we forget to rcu_read_unlock()
> on error path.

Er...  Where could we ever get called with size zero?  IOW, the
real question is whether that check makes any sense.  If nothing
else, a much more obvious fix (again, assuming there is a call
chain that could have triggered that in the first place), would
be to take that
        if (buflen < 1)
                goto Elong;
on the very top of __dentry_path().  Note that buflen never
change, so this check could bloody well be handled once - and
earlier.  But again, the callers shouldn't be calling it that
way...
