Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaKLQ2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:28:07 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:22814 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaKLQ2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:28:04 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 11:28:04 EST
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-LoopCount0:X-IronPort-AV:From:To:CC:Date:Subject:
   Thread-Topic:Thread-Index:Message-ID:References:
   In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=kDfP7XJ3m6qSmeqJaVVSKhnPsgeNruvlVPFQusoQdpi+F+FeHHROAO8a
   JpA7eTi4mrDY4kIFsQkd337FqSqHkuPlOhomm003uME6zGx4hzgG0mZz4
   0dS1jKMLDDoWi0UgzahKHdDRlrPn0DXnurgZ2inIiwy2dusLKDTCKJaGX
   k=;
X-LoopCount0: from 10.170.28.41
X-IronPort-AV: E=Sophos;i="5.07,369,1413262800"; 
   d="scan'208";a="587902337"
From: <Jordan_Hargrave@Dell.com>
To: <bhelgaas@google.com>, <David_Waggoner@Dell.com>, <Austin_Bolen@Dell.com>
CC: <jdmason@kudzu.us>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 12 Nov 2014 10:18:25 -0600
Subject: PCI Max payload setting
Thread-Topic: PCI Max payload setting
Thread-Index: AQHP/pDduV5SBP6wf0S8KnwE9n5NTw==
Message-ID: <5B3AAEAF6B46EA4D955DF7AD46C2C48516886FB954@AUSX7MCPS303.AMER.DELL.COM>
References: <20141104162251.GF10744@8bytes.org>,<CAErSpo4Zx8hNjJdHvJeLzj_wAJSa6WCDuJ0XYymK-QU_i+MECg@mail.gmail.com>
In-Reply-To: <CAErSpo4Zx8hNjJdHvJeLzj_wAJSa6WCDuJ0XYymK-QU_i+MECg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon,

  We are still seeing problems with the current implementation of PCIE MaxPayload setting with hotplug devices (PCIE SSD).

The original implementation I proposed a few years ago used a bottom-up approach for configuring a PCI device when it was added to the system.
It would read the Parent MPS setting and configure the device to the speed of the parent (or fail to configure the device if parent speed was above device capability).

The implementation in the kernel uses a top-down approach, it is scanning all children devices and potentially setting the bridge speed based on the capability of child devices.  If the default setting is ued (pcie_bus_config = PCIE_BUS_TUNE_OFF) this causes the device to fail as the default speed is 128 and bridge is configured to 256 or greater.  The workaround for that is setting pcie_bus_perf.  However I have seen issues with this on some systems if an I/O transaction is occurring (RAID card) while the bridge speed is being changed. 

We have had to use my original code in both the mtip32xx and nvme drivers to support hotplug properly on our systems due to these shortcomings.

I am looking for a solution that will work properly on our systems out of the box.  I think the bottom-up approach is still best.  We are assuming the BIOS has already setup the payload of the bridges to optimal value.

--jordan hargrave
Dell Enterprise Linux Engineering
