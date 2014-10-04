Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaJDK6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:58:46 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:40197 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaJDK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:58:45 -0400
MIME-Version: 1.0
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Sat, 4 Oct 2014 20:28:14 +0930
Message-ID: <CAGf84QKbuC7KNcG1GhUJyRktwekVg8HV7zLCv7wbx6qjjJXxSw@mail.gmail.com>
Subject: [REGRESSION] ACPI / EC: Events not being cleared on Samsung series 9 laptop
To: "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since updating to kernel 3.16.3 I have noticed that an old bug has
returned where EC events like lid open/close and ambient light change
are no longer being processed on my Samsung notebook (900X3C).

Most of this was previously documented in:

Samsung Series 9 np900x4b: ACPI does not seem to reflect charging/discharging...
https://bugzilla.kernel.org/show_bug.cgi?id=44161

A workaround was added to the kernel at the time:

ad332c8a45330d170bb38b95209de449b31cd1b4
ACPI / EC: Clear stale EC events on Samsung systems

3eba563e280101209bad27d40bfc83ddf1489234
ACPI / EC: Process rather than discard events in acpi_ec_clear

That seemed to have solved the problem, but it seems that a recent
change between

66b42b78bc1e816f92b662e8888c89195e4199e1
ACPI / EC: Avoid race condition related to advance_transaction()

and

558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4
ACPI / EC: Add support to disallow QR_EC to be issued before
completing previous QR_EC

Has reintroduced this bug. I have not had time to fully test this
myself, but someone else who noticed the same regression has now
posted in the kernel bugzilla link above reporting that:

> I've narrowed it down to the following commits:
>
> ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set
> 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08
>
> ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC
> 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4
>
> On 3.17rc7, reverting the latter seems to solve the issue for acpi events related to
> the power supply, however LID switch is still broken.
> Reverting both seems to resolve the issue completely.

Can anyone (Lv Zheng) think of why these patches have caused this
issue on this hardware? Maybe we need to modify the patches above to
do something different in case EC_FLAGS_CLEAR_ON_RESUME is set?

Regards,
Kieran Clancy
