Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaGJSzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:55:09 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33773 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaGJSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:55:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-2-git-send-email-hskinnemoen@google.com>
	<20140709191747.GB5249@pd.tnic>
	<CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
	<20140710114222.GE2970@pd.tnic>
	<CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
Date: Thu, 10 Jul 2014 11:55:06 -0700
Message-ID: <CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
From: Tony Luck <tony.luck@gmail.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:51 AM, Havard Skinnemoen
<hskinnemoen@google.com> wrote:
> What's the typical interrupt rate during a storm? We should make it
> significantly less frequent than that, otherwise there's no point
> switching to polling.
>
> IIRC we've seen at least several hundred CMCIs per second, so perhaps
> 100 ms would be a reasonable minimum? Or perhaps 10 ms, which is the
> current minimum polling interval enforced by mce_timer_fn.

I don't think we have a solid point to really declare "storm!".  The
CMCI rates between normal and abnormal rates are vast:

Normal rates are a few CMCI per year (or maybe per month ... if
you have a multi-terabyte machine perhaps even "per day" is normal).

So if you see two CMCI inside the same minute, you could declare
a storm.  Realistically we want the threshold a bit higher.

It then becomes a balance between seeing all the errors (so our PFA
mechanisms get enough data to spot bad pages and take action) and
processing so many interrupts that we begin to take a performamce
hit.

Once we do decide there is a storm - we know we have given up on
seeing all the errors ... the polling rate will only decide how fast we
can determine that the storm has ended.  I don't see a lot of value
in detecting the end at milli-second granularity. But we probably don't
want to give up minutes worth of PFA data if the storm does end.

-Tony
