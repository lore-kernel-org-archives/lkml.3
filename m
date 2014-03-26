Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaCZDCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbaCZDCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:02:31 -0400
Message-ID: <1395802940.16116.16.camel@localhost>
Subject: Re: Linux 3.14-rc8 (LXC broken)
From: Eric Paris <eparis@redhat.com>
To: Andre Tomt <andre@tomt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Date: Tue, 25 Mar 2014 23:02:20 -0400
In-Reply-To: <5331E8CB.3060708@tomt.net>
References: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
	 <5331E8CB.3060708@tomt.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 21:36 +0100, Andre Tomt wrote:
> *testing hat on*
> 
> PAM within namespaces (say, LXC) does not work anymore with 3.14-rc8,
> making login, ssh etc fail in containers unless you boot with audit=0.
> 
> This is due to a change in return value to user space; and is
> appearantly a known issue as evident in this earlier post from february:
> https://www.redhat.com/archives/linux-audit/2014-February/msg00087.html
> 
> Judging from the post it seems they want to ship 3.14 with this IMO
> quite serious regression? What is the namespace/container folks take on
> this?

Fair question.

Pam only worked in non-initial pid (or user) namespace if it was also in
the non-initial network namespace.  We added support for the network
namespace in 3.14.  So now PAM in the non-initial network namespace
functions the same as it would in the inital network namespace.  aka, it
fails.  This is actually what the audit userspace people think is the
right thing to happen.  You configured PAM to fail if it couldn't do the
right audit things, and it's failing.  Needing audit=0 is not new.

BUT given we broke (already broken [remember you configured PAM to fail
if audit didn't go well and it let you log in anyway?  aka broken?])
functionality adding network namespace support I'll send a request to
Linus tomorrow to rip out our network namespace support and I'll re-add
in 3.15 when we add pid (and partial user) namespace support.

-Eric

