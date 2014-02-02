Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaBBHJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 02:09:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaBBHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 02:09:49 -0500
Date: Sun, 2 Feb 2014 08:11:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Driver Project <devel@linuxdriverproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Staging wireless driver for 3.14-rc1
Message-ID: <20140202071114.GA2195@kroah.com>
References: <20140131143203.GA6560@kroah.com>
 <CA+55aFx2WsAzo8pNDs1B4RUnsAhhWE3-YNO38x4y-dW05g=yTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx2WsAzo8pNDs1B4RUnsAhhWE3-YNO38x4y-dW05g=yTQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 10:43:11AM -0800, Linus Torvalds wrote:
> On Fri, Jan 31, 2014 at 6:32 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Here's a single staging driver for a wireless chipset that has shown up
> > in the SteamBox hardware.  It is merged separately from the "main"
> > staging pull request to sync up with the wireless api changes that came
> > in from the networking tree.
> 
> It causes an interesting warning for me:
> 
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function
> ‘rtl8821ae_dm_clear_txpower_tracking_state’:
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u
> invokes undefined behavior [-Waggressive-loop-optimizations]
>    rtldm->bb_swing_idx_ofdm[p] = rtldm->default_ofdm_index;
>                                ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
>   for (p = RF90_PATH_A; p < MAX_RF_PATH; ++p) {
>   ^
> 
> and gcc is entirely correct: that loop iterates from 0 to 3, and does this:
> 
>                 rtldm->bb_swing_idx_ofdm[p] = rtldm->default_ofdm_index;
> 
> but the bb_swing_idx_ofdm[] array only has two members. So the last
> two iterations will overwrite bb_swing_idx_ofdm_current and the first
> entry in bb_swing_idx_ofdm_base[].
> 
> Now, the bug does seem to be benign: bb_swing_idx_ofdm_current isn't
> actually ever *used* as far as I can tell, and the first entry of
> bb_swing_idx_ofdm_base[] will have been written with that same
> "rtldm->default_ofdm_index" value.
> 
> But gcc is absolutely correct, and that driver needs fixing.
> 
> I've pulled it and will let it be because it doesn't seem to be an
> issue in practice, but please fix it. The obvious fix would seem to
> change the size of "2" to be "MAX_RF_PATH", but I'll abstain from
> doing those kinds of changes in the merge when it doesn't seem to
> affect the build or functionality).

Ok, thanks, someone's already sent me that patch to fix this up, I'll
queue it up for the post-rc1 set of staging tree fixes.

greg k-h
