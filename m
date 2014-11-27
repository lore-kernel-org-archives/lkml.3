Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaK0JUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:20:08 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50151 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaK0JUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFox8bXyFT0861Tc8YY5HLyq5uPVGkfN0G4fXDKqQynkYQ@mail.gmail.com>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan>
	<CAPDyKFox8bXyFT0861Tc8YY5HLyq5uPVGkfN0G4fXDKqQynkYQ@mail.gmail.com>
Date: Thu, 27 Nov 2014 10:20:03 +0100
Message-ID: <CAPDyKFqrpysnZcV-JwoSrEddmQUMfj9uYvmbVLNL7-fRQyTYFQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] PM: Use CONFIG_PM instead of CONFIG_PM_RUNTIME in
 core code
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 09:57, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 27 November 2014 at 01:37, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Hi,
>>
>> After commit b2b49ccbdd54 "PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
>> selected" (currently in Linux next) CONFIG_PM_RUNTIME is set whenever
>> CONFIG_PM is set, so CONFIG_PM can be used in #ifdefs instead of
>> CONFIG_PM_RUNTIME which simplifies things in quite a few cases.
>>
>> For this reason, the following patches modify some core code to use
>> CONFIG_PM instead of CONFIG_PM_RUNTIME.
>>
>> [1/4] Drop a macro which is redundant after the above commit.
>> [2/4] Use PM instead of PM_RUNTIME in the core device PM code.
>> [3/4] Use PM instead of PM_RUNTIME in the ACPI core.
>> [4/4] Use PM instead of PM_RUNTIME in the PCI core.
>>
>> They build for me for all of the relevant combinations of options (on x86),
>> but more testing (on the other architectures) would be welcome.
>
> I really like the looks of this patchset!
>
> Noticed that you have applied it for your bleeding edge branch, I
> suppose that means you will get some "free" testing in linux-next?
>
> Anyway, I have tested it for ux500 (including the genpd support for
> it, available in linux-next). It works nicely!
>
> I have also tested the two Kconfig options; CONFIG_PM_SLEEP (which
> selects CONFIG_PM_RUNTIME) and for CONFIG_PM_RUNTIME (with
> CONFIG_PM_SLEEP unset).
>
> That brings me to a raise a question; why do we need to keep these two
> configurations options? Couldn't we also have CONFIG_PM_RUNTIME to
> select CONFIG_PM_SLEEP, that will further simplify things?
>

I had look at it. Do you think the below approach could work?

I guess the questions is if there are some configurations that use
CONFIG_PM_RUNTIME but not CONFIG_PM_SLEEP. And if so, should we care?

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 6e7708c..425f83a 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -94,7 +94,6 @@ config PM_STD_PARTITION
 config PM_SLEEP
        def_bool y
        depends on SUSPEND || HIBERNATE_CALLBACKS
-       select PM_RUNTIME

 config PM_SLEEP_SMP
        def_bool y
@@ -131,21 +130,12 @@ config PM_WAKELOCKS_GC
        default y

 config PM_RUNTIME
-       bool "Run-time PM core functionality"
-       ---help---
-         Enable functionality allowing I/O devices to be put into energy-saving
-         (low power) states at run time (or autosuspended) after a specified
-         period of inactivity and woken up in response to a hardware-generated
-         wake-up event or a driver's request.
-
-         Hardware support is generally required for this functionality to work
-         and the bus type drivers of the buses the devices are on are
-         responsible for the actual handling of the autosuspend requests and
-         wake-up events.
+       def_bool y
+       depends on PM_SLEEP

 config PM
        def_bool y
-       depends on PM_SLEEP || PM_RUNTIME
+       depends on PM_SLEEP


Kind regards
Uffe
