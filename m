Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaECSZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:25:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36770 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaECSZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:25:30 -0400
Date: Sat, 3 May 2014 19:25:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140503182528.GO18016@ZenIV.linux.org.uk>
References: <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
 <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFzbtGwxTf_d97pSLc4hAciErGDdkOSzLkpt_hP-UmLPWg@mail.gmail.com>
 <20140502224022.GJ18016@ZenIV.linux.org.uk>
 <20140503042604.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwA57CEkCrRTrNUgtVxSFvaVfRfbi=MEqWzpm+2igEpmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwA57CEkCrRTrNUgtVxSFvaVfRfbi=MEqWzpm+2igEpmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 11:07:57AM -0700, Linus Torvalds wrote:
> Sure, umount itself should be serialized by the sb lock, so there
> should be only one umount dentry collector. But why wouldn't there be
> shrinkers active due to memory pressure?
> 
> generic_unmount_super() is called by ->kill_sb(), which is done
> *before* the superblock shrinker is unregistered  So any memory
> pressure during that will cause dentries to be shrunk other ways.
> 
> What am I missing?

This:
        if (!grab_super_passive(sb))
                return SHRINK_STOP;
before calling prune_dcache_sb().  grab_super_passive() returns with
->s_umount held shared on success (with down_read_trylock()) and ->kill_sb()
is called only with ->s_umount held exclusive.
