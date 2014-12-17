Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaLQQv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:51:58 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63365 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaLQQv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:51:56 -0500
Message-ID: <5491B4A8.905@amacapital.net>
Date: Wed, 17 Dec 2014 08:51:52 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-efi@vger.kernel.ogr, LKML <linux-kernel@vger.kernel.org>
Subject: EFI mixed mode + perf = rampant triple faults
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I figured I should send this email before I forget about this issue:

If you run perf record across any EFI mixed mode call or otherwise
receive an NMI or MCE, the machine triple-faults.  The cause is
straightforward: there is no valid IDT when we have long mode disabled
for the duration of the EFI call.

As far as I know, the only way to have continuously functional interrupt
handling across a long mode transition is to install an interrupt vector
table and hope that CPUs actually do something intelligent when
receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.

Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
with a 32-bit CPL0 CS but while still in long mode?  I think that
delivery of an IST interrupt (which includes both NMI and MCE) will
correctly switch to a fully valid 64-bit state and would correctly
switch back when we execute IRET at the end.  (Am I missing some reason
that switching bitness without a privilege level change doesn't work
well?  I haven't thought of anything, other than the lack of SS controls
on intra-ring interrupts, but that shouldn't be an issue here.)

As an added benefit, this would considerably simplify the code.

--Andy
