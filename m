Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3HFOPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:15:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58024 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3HFOPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:15:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rafael.j.wysocki@intel.com, yinghai@kernel.org, toshi.kani@hp.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: acpi_bus_trim does not detach devices in post order
Date: Tue, 06 Aug 2013 16:26:03 +0200
Message-ID: <8453998.khIH1RyxM0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5200CAAD.5080102@jp.fujitsu.com>
References: <52006888.5030203@jp.fujitsu.com> <5200CAAD.5080102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 07:06:37 PM Yasuaki Ishimatsu wrote:
> (2013/08/06 12:07), Yasuaki Ishimatsu wrote:
> > 
> > I acked the following commit but I hit a problem by the commit.
> > So I report it.
> > 
> > commit cecdb193c8d91a42d9489d00618cc3dfff92e55a
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Tue Jan 15 13:24:02 2013 +0100
> > 
> >      ACPI / scan: Change the implementation of acpi_bus_trim()
> > 
> > Before applying the commit, acpi_bus_trim() detachs devices in post order.
> > 
> > When I hot add memory devices and processor devices by container device
> > in my x86 box, memory devices are added first and processor devices are added
> > second. So I expect that processor devices are removed first and memory
> > devices are removed second when I remove them. And before applying the
> > commit, acpi_bus_trim() did so.
> > 
> > But after appling the commit, acpi_bus_trim() does not detach devices in
> > post order. So when I remove them, memory devices are removed first and
> > processor devices are removed second.
> > 
> > By this, I hit a problem.
> > 
> > In Linux on x86 arch, NUMA node is depend on memory devices. So new NUMA
> > node is created at memory hot adding. Thus when I hot add memory devices and
> > processor devices, we must hot add memory device first. Otherwise, processor
> > devices are not set to correct NUMA node number.
> > 
> > And Linux expects that when removing them, processor devices are removed
> > first before removing memory devices. But acpi_bus_trim() does not do so.
> > By this, NUMA node is not cleared in my x86 box when hot removing memory device
> > and processor devices. When removing memory devices, NUMA node is cleared.
> > But if there are processor devices related with the NUMA node, NUMA node is
> > not be cleared at memory hot removing.
> > 
> > So when I remove them, NUMA node's sysfs file remained as follows:
> 
> I had little mistake. CPU also tries to clear NUMA node.
> But current implementation has bug. So I'll fix it.

Do I understand correctly that with your fix at

https://patchwork.kernel.org/patch/2839298/

the current acpi_bus_trim() implementation will be sufficient?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
