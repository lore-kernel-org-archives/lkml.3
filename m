Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaLEUM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:12:57 -0500
Received: from ida.rowland.org ([192.131.102.52]:50014 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751631AbaLEUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:12:49 -0500
Date: Fri, 5 Dec 2014 14:18:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@ida.rowland.org
To: Chuansheng Liu <chuansheng.liu@intel.com>
cc: bhelgaas@google.com, <rjw@rjwysocki.net>, <mister.freeman@laposte.net>,
        <aaron.lu@intel.com>, <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] PCI: Add disabling pm async quirk for JMicron chips
In-Reply-To: <1417763857-11993-1-git-send-email-chuansheng.liu@intel.com>
Message-ID: <Pine.LNX.4.44L0.1412051415180.13167-100000@ida.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2014, Chuansheng Liu wrote:

> Some history from
> commit e6b7e41cdd8c ("ata: Disabling the async PM for JMicron chip 363/361")
> ==
> Since v3.15, the PM feature of async noirq
> commit 76569faa62c4 ("PM / sleep: Asynchronous threads for resume_noirq") is introduced.
> 
> Then Jay hit one system resuming issue that one of the JMicron controller
> can not be powered up successfully.
> 
> His device tree is like below:
>                  +-1c.4-[02]--+-00.0  JMicron Technology Corp. JMB363 SATA/IDE Controller
>                  |            \-00.1  JMicron Technology Corp. JMB363 SATA/IDE Controller
> 
> After investigation, we found the the Micron chip 363 included
> one SATA controller(0000:02:00.0) and one PATA controller(0000:02:00.1),
> these two controllers do not have parent-children relationship,
> but the PATA controller only can be powered on after the SATA controller
> has finished the powering on.
> 
> If we enabled the async noirq(), then the below error is hit during noirq
> phase:
> pata_jmicron 0000:02:00.1: Refused to change power state, currently in D3
> Here for JMicron chip 363/361, we need forcedly to disable the async method.

You know, this is exactly why device_pm_wait_for_dev() exists -- so 
that asynchronous power-management operations can wait for other 
devices even when there's no parent-child relation.

You should try to use device_pm_wait_for_dev() instead of disabling 
async suspend/resume.

Alan Stern

