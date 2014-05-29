Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaE2LU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:20:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57790 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaE2LU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:20:56 -0400
Date: Thu, 29 May 2014 13:20:49 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
Message-ID: <20140529112049.GA23862@ubuntu-mba51>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>,
	Marian Marinov <mm@1h.com>, Eric Biederman <ebiederm@xmission.com>,
	Richard Weinberger <richard.weinberger@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael J Coss <michael.coss@alcatel-lucent.com>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <5386758C.4040702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386758C.4040702@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:47:24PM -0700, H. Peter Anvin wrote:
> On 05/27/2014 02:58 PM, Seth Forshee wrote:
> > 
> > The patches implement a psuedo filesystem for loop devices, which will
> > allow use of loop devices in containters using standard utilities. Under
> > normal use a loopfs mount will initially contain a single device node
> > for loop-control which can be used to request and release loop devices.
> > Any devices allocated via this node will automatically appear in that
> > loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
> > CAP_SYS_ADMIN in the userns of the process which performed the mount is
> > allowed to perform privileged loop ioctls on these devices.
> > 
> > Alternately loopfs can be mounted with the hostmount option, intended
> > for mounting /dev/loop in the host. This is the default mount for any
> > devices not created via loop-control in a loopfs mount (e.g. devices
> > created during driver init, devices created via /dev/loop-control, etc).
> > This is only available to system-wide CAP_SYS_ADMIN.
> > 
> 
> May I instead strongly advocate a slightly different solution: leave
> legacy loop devices where they are, with the current semantics, and let
> them be.  Make the loopfs loop devices completely independent.  Consider
> this equivalent of Unix98 ptys versus legacy BSD ptys.
> 
> Then, hopefully, use of the legacy ones will disappear over time.
> Enabling the new ones in losetup and friends is simple enough; this is
> not like ptys where the old scheme was hard-coded into a hundred
> different applications.

I'm not really sure what you're thinking should be changed about the
loop driver. Sure, I can think of a few things I'd change, but nothing
intractable.

If it's the semantics, I'm not really changing those in any significant
way. Today losetup opens /dev/loop-control and asks for a free device,
and it receives either an existing, unused device or a new device which
appears at /dev/loopN. All that changes here is that it would need to
try /dev/loop/loop-control as well, and devices would appear at
/dev/loop/N (which is a convention losetup already understands, it just
needs to look there in some cases where it doesn't currently).

Or perhaps you're suggesting a more radical change to the semantics?

Thanks,
Seth

