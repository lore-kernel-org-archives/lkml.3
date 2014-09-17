Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbaIQNsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:48:35 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60459 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaIQNsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <54194A4A.7030104@zytor.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
	<CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
	<54194A4A.7030104@zytor.com>
Date: Wed, 17 Sep 2014 06:48:32 -0700
Message-ID: <CADU+-uDDxwTbKQbNqgDr2F5ZPw957as+mCRJkf-7zxjNBphkLQ@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
From: Filipe Brandenburger <filbranden@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Richard Larocque <rlarocque@google.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Davidson <md@google.com>, Greg Thelen <gthelen@google.com>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 17, 2014 at 1:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Why would we need/want per process vvar contents?  It seems better to
> have the code swapped out.

We are looking at the migration use case (CRIU).

In specific, we want to make CLOCK_MONOTONIC keep the "monotonic"
promise after migration. In order to accomplish that, we may need to
add an offset to CLOCK_MONOTONIC calls after migration.

By keeping a per process vvar page we should be able to implement that
without having to fallback to a real syscall for calls to
clock_gettime(CLOCK_MONOTONIC).

One other thought was that we could use this process vvar page to
expose a migration counter that would get incremented after migration.
That way we could allow (some) userspace tasks (and possibly some VDSO
routines) to use RDTSC but check the contents of that counter
before/after taking measurements to check whether the elapsed time is
valid or not. That means we could still provide tasks with a fast time
counter if they really need one.

Cheers,
Filipe
