Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaK0OUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:20:45 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:55132 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaK0OUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:20:43 -0500
MIME-Version: 1.0
In-Reply-To: <CADGdYn6fAScrpz4Va=THtC1ZgT+rYN_gQuE6NnRaCiN4NErg5g@mail.gmail.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
	<1416834256-11225-7-git-send-email-amit.daniel@samsung.com>
	<CAPDyKFqE_qhrRs3X9s9juyPH_Zcq8vdE_amqKM3VUnMjHtL2Rg@mail.gmail.com>
	<CADGdYn6fAScrpz4Va=THtC1ZgT+rYN_gQuE6NnRaCiN4NErg5g@mail.gmail.com>
Date: Thu, 27 Nov 2014 15:20:42 +0100
Message-ID: <CAPDyKFo0epKqKuwHS_CKMG2hF+J=Fdve9kPK2EVeeR7FvdoJmg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 07/12] PM / Domains: export pm_genpd_lookup_name
From: Ulf Hansson <ulf.hansson@linaro.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2014 at 09:48, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> On Tue, Nov 25, 2014 at 1:05 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 24 November 2014 at 14:04, Amit Daniel Kachhap
>> <amit.daniel@samsung.com> wrote:
>>> This API may be needed to set the power domain parent/child relationship
>>> in the power domain platform driver. The parent relationship is
>>> generally set after the child power domain is registered with the power
>>> domain subsystem. In this case, pm_genpd_lookup_name API might be
>>> useful.
>>
>> I think this is a step in the wrong direction. Instead we should be
>> working on removing the "name" based APIs from genpd.
>>
>> The proper way should be to pass the PM domain as a parameter to the
>> APIs instead.
> Yes i understand but i had a special requirement for using this API
> during pd probe.
>  I cannot use hierarchy to represent parent/child pd nodes as it will
> break the existing SoC's. In my case all the PD nodes are linear. The
> parent/child relationship are established in the second pass after all
> the PD entries are registered with the help of this API.
> Although there a way that i can always keep parent PD's before the
> child PD's in DT in linear order. Will check this approach.

I had some thinking around this, could the below approach work?

I just posted a patch[1] adding a new pm_genpd_lookup() API, which is
using a "DT device node" to fetch the genpd. The idea is to use that
API to get the genpd handle which is needed to configure a subdomain
through pm_genpd_add_subdomain() API.

In principle you will have to walk through the DT a couple of times,
initialize those domains (and subdomains) which either don't have a
parent domain or which parent domain already has been initialized. I
guess you need a somewhat clever loop to do that, but I think it's
doable.

Obviously we also need to have a generic binding for a "parent
domain". I like Geert's proposal from the other patch, which means
using "power-domains = <&pd_xyz>".

Kind regards
Uffe

[1]
http://marc.info/?l=linux-pm&m=141709766008458&w=2
