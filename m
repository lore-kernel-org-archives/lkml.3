Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbaBAVRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 16:17:34 -0500
Received: from science.horizon.com ([71.41.210.146]:41364 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932270AbaBAVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 16:17:13 -0500
Date: 1 Feb 2014 16:17:10 -0500
Message-ID: <20140201211710.20281.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, torvalds@linux-foundation.org
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, linux@horizon.com,
        maarten-baert@hotmail.com, mingo@kernel.org, nate@thatsmathematics.com,
        priikone@iki.fi, sbsiddha@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org
In-Reply-To: <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> .. which *does* actually bring up something that might work, and might
> be a good idea: remove the "restore math state or set TS" from the
> normal kernel paths *entirely*, and move it to the "return to user
> space" phase.

This definitely seems much more sensible.  For processors without
optimized context save/restore, the decision whether to restore eagerly
is best made once the kernel has decided what it's returning *to*.

>From an interrupt handler, there are now three cases:
1) FPU not in use, available for immediate use.
2) FPU in use by user-space; save to <location> before using.
3) FPU in use by kernel code; may not be used (unless we want
   to add nested FPU state save hair).
