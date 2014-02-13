Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaBMMPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:15:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBMMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:15:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linaro-kernel@lists.linaro.org, devicetree@vger.kernel.org,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from device tree
Date: Thu, 13 Feb 2014 13:15:29 +0100
Message-ID: <4739375.bEm7oed1OF@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140213115327.GV26684@n2100.arm.linux.org.uk>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <3204351.WykFFcX4zJ@wuerfel> <20140213115327.GV26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Vo60oMSGf1Fad4EJ7oLi/NHlmYKjNSESXqp3/IxPXgv
 DHA9piyO5WG6T9yi/LXLvpwa6Gydw3QwqSK1Pzsm+E74knCEuM
 ogDO56EySyBcNhr3lpgdcRto/rccRB/llp/eY58T/El26ZJNyU
 tMKYdGOq4OAyaZ2FLESiaBza6A3JrVOXOv+s6lwpzKdOgNeM1m
 G7/nywug1fQxU2axC/w0MUmz5rpsRzkf7b3j4DQ40XvIyZDnfb
 /QEuWbYrpfR8EUmCkrXRqia33TW9vYDGiMVtt9pdV+BrnIJMeg
 G7hsXHMzaOfam80wtCUlqWVpbKa4l5AJCAhCth4fh16tAsbTMM
 3aSfG0PRLK9uUJ0lGZus=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 February 2014 11:53:27 Russell King - ARM Linux wrote:
> On Thu, Feb 13, 2014 at 12:27:05PM +0100, Arnd Bergmann wrote:
> > I would rather get rid of struct hw_pci for architecture independent
> > drivers and add a different registration method on arm32 that is
> > compatible with what we come up with on arm64. The main purpose of
> > hw_pci is to allow multiple PCI controllers to be initialized at
> > once, but we don't actually need that for any of the "modern" platforms
> > where we already have a probe function that gets called once for
> > each controller.
> 
> No.  The main purpose of hw_pci is as a container to support multiple
> different platform specific PCI implementations in one kernel.  It's
> exactly what you need for single zImage.

Well, we definitely need something to manage the assignment of domains,
bus numbers and I/O space windows, but the main issue I see with existing
hw_pci container is that it assumes that you can pass give it all
host bridges for a given domain at once. The problem with this is
that the pci host bridge drivers don't interact with one another, so
a system that needs two different PCI host drivers can't use hw_pci
to register them both, unless we come up with some extra
infrastructure.

Also, the calling conventions for pci_common_init_dev() mean that
it's hard to propagate -EPROBE_DEFER errors back to the driver
probe function, so it seems easier to come up with something new
that deals with all issues at once and that is outside of architecture
specific code.

	Arnd
