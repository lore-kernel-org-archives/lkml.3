Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaIJG4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:56:33 -0400
Received: from goliath.siemens.de ([192.35.17.28]:47046 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:56:32 -0400
Message-ID: <540FF614.8000003@siemens.com>
Date: Wed, 10 Sep 2014 08:56:20 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>, jroedel@suse.de
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Gary Kroening <gfk@sgi.com>
Subject: Re: [RFC] iommu/vt-d: Use the SIRTP when enabling remapping
References: <1410297096-54096-1-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1410297096-54096-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-09 23:11, Nathan Zimmer wrote:
> The previous change (iommu/vt-d: Don't store SIRTP request) to this area
> caused a crash in our simulator. In particular is seems that by the time a
> UART interrupt is sent through the system, we don't see interrupt remapping
> to be enabled.  So the interrupt does not get translated to a logical
> interrupt and crashes.
> 
> OR'ing the SIRTP request to make sure it is seen but hopefully not sticky.
> This seems like a clean fix, at least on our simulator; if you don't agree,
> our simulator guy will take a closer look at our iommu model.

Check the VT-d spec (6.7, Set Interrupt Remapping Table Pointer
Operation): "Software must always follow the interrupt-remapping table
pointer set operation with a global invalidate of the IEC to ensure
hardware references the new structures *before* enabling interrupt
remapping." There is also (command register description): "If multiple
control fields in this register need to be modified, software must
serialize the modifications through multiple writes to this register."
This, in combination with the command registers description of bits 24
and 25 strongly suggests that your model is broken.

> 
> Found testing on our simulator, not real hardware.

Funnily, the original issue was found by the QEMU model of VT-d that
used to take the last cited sentence very strictly (I asked to remove it
due to the preexisting Linux versions).

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
