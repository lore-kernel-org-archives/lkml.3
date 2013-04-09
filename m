Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936809Ab3DIOwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:52:13 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58665 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3DIOwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:52:12 -0400
Date: Tue, 09 Apr 2013 09:52:08 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC] rootmpfs
To: Byron Stanoszek <bstanoszek@comtime.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1304051547440.2314@winds.org> (from
	bstanoszek@comtime.com on Fri Apr  5 14:53:12 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365519128.18069.55@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 02:53:12 PM, Byron Stanoszek wrote:
> Rob,
> 
> FWIW I have a patch to do something like this. It even gives you a  
> rdsize=xxx
> tunable kernel parameter that lets you specify the size of the tmpfs,  
> which
> acts like the -osize= mount flag (so phrases like 100M or 20% works).  
> So doing
> things like 'cat /dev/zero > filename' will not run you out of all  
> available
> memory. (Note: If you don't specify rdsize= on the kernel command  
> line, it will
> not convert rootfs to tmpfs).

In init/do_mounts.c the boot infrastructure already has kernel command  
line options "rootflags=" and "rootfstype=", so the logical thing to do  
is probably to hook those up to rootfs. (That way instead of special  
casing a new option we use the existing tmpfs option parsing.)

The default tmpfs size is 50%, which solves the "trivial to exhaust  
memory and panic a kernel running under rootfs" problem. Having one  
tmpfs also fixes the case that multiple tmpfs mounts (for /home and  
/var, for example,) have separate memory limits that don't coordinate  
with each other, so if /home can use 30% and /var can use 30%, that's  
60% plus whatever rootfs is already using, so you can easily squeeze  
the kernel against the wall without meaning to. (Yes, you can make one  
tmpfs mount and --bind mount from there to elsewhere, I've seen that  
done. Having rootfs just _be_ tmpfs makes this much easier to track.)

> See attached.

You're not actually changing the type of rootfs, you're overmounting it  
with a second filesystem instance. (Mine hasn't got a "change", it just  
mounts it correctly the first time, and there's just one rootfs  
instance.)

What _is_ wrong with my version is that if you select tmpfs as a module  
bad things happen; it tries to use code that's not there. I dunno of an  
#ifdef that distinguishes between module and builtin, so I think I have  
to add another kconfig symbol...

I'll poke at it.

Rob