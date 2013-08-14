Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3HNUy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:54:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52881 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab3HNUyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130814104938.GF4491@8bytes.org>
References: <002701ce941a$eecebdb0$cc6c3910$@samsung.com>
	<1516548.d7oQuzQS7g@amdc1227>
	<CANEJEGu1ponghpfvyUsQX16+TZWUV+0KXJ7AehjXpju2N_H+Ew@mail.gmail.com>
	<20130814104938.GF4491@8bytes.org>
Date: Wed, 14 Aug 2013 13:54:53 -0700
X-Google-Sender-Auth: NdghCUuyy5NheV4lSshxgv_UW1E
Message-ID: <CANEJEGveOtGs8XEYFnnXoZ575bqKRkc3AMikr_1x02cNikwTng@mail.gmail.com>
Subject: Re: [PATCH v9 03/16] iommu/exynos: fix page table maintenance
From: Grant Grundler <grundler@chromium.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Grant Grundler <grundler@chromium.org>, Tomasz Figa <t.figa@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 3:49 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Thu, Aug 08, 2013 at 11:28:44AM -0700, Grant Grundler wrote:
>> I can't speak to the previous BUG_ON(). I believe the EADDRESSINUSE
>> failures could be either WARN_ON or BUG_ON.   This condition is
>> clearly a bug in the generic IOMMU allocator and I think that's why
>> KyongHo Cho used BUG_ON.
>>
>> Handing out duplicate addresses will generally lead to some sort of
>> data corruption or other fault depending on how robust the underlying
>> device drivers are written.  So my preference is a BUG_ON to
>> immediately flag this condition instead of hoping a device driver will
>> correctly handling the dma mapping failure (Some do, most currently
>> don't).
>>
>> WARN_ON() + return -EADDRESSINUSE would be a good alternative.
>
> Even if it is a real BUG condition, I don't think it is worth to stop
> execution at this point. It makes debugging harder and the system less
> reliable. I prefer to go with the WARN_ON and an error return value.

I'm ok with WARN_ON and an error return value. This is "valid"
behavior.  I expect this bug to never happen but if and when it does,
I want a clear symptom (e.g. WARN_ON) that it happened.

My concern is that historically, drivers did not get an error return
value on failure:
    ftp://193.166.3.4/pub/linux/kernel/v2.3/patch-html/patch-2.3.47/linux_Documentation_DMA-mapping.txt.html

or later:
    https://www.kernel.org/pub/linux/kernel/people/marcelo/linux-2.4/Documentation/DMA-mapping.txt

And thus, some drivers don't check or attempt to handle mapping
failures based on this existing code. Here is a recent example:
     http://comments.gmane.org/gmane.linux.network/272969

I hope very few or none of those exist since Neil Horman demonstrated
"dma debugging" can flag this behavior.

Just for fun, I'll include this link : (apperently 2003 was a good
year for DMA talks :)
     http://ols.fedoraproject.org/OLS/Reprints-2003/LinuxSymposium2003-2side.pdf
     (three talks on DMA issues)

thanks
grant
