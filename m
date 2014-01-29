Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaA2Tg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:36:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaA2Tgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:36:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
Date: Wed, 29 Jan 2014 20:36:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, Jon Masters <jcm@redhat.com>,
        linux-doc@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com> <5086198.ZOWZ5xuyna@wuerfel> <CACoXjcnTnhWS-5yOgiHA5yVaBjdH1DVzmSsknEBJLB+CFR0EyA@mail.gmail.com>
In-Reply-To: <CACoXjcnTnhWS-5yOgiHA5yVaBjdH1DVzmSsknEBJLB+CFR0EyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401292036.34501.arnd@arndb.de>
X-Provags-ID: V02:K0:S+nCDi3R7xUJXVD/7dGJzPaIp3UNmgBxa+LtujiUk18
 CP2voxXD7wrIvdoc4w1eZS0mhN3I7qBZaBaGvHnRf5GecZYkrT
 suPSDAg6YaXNRNQk9oYmyYnSwwj+HJRm6qNKL2twCi80ANOyP0
 b+JaWIqS1ZAJsx9brXje4uXpIuhLFpLL5b4ZQ/Ykkl4qcBH6/I
 WDbfWgfWuKbvixvaW6TcADq5OfmrMco0/PdZIid7YUnVW0502V
 bsuO5Xjl+2phS4Raoa7LBotu0CMf8oofDgKv8fWvzFP5Vfxjlf
 A2iT5CfG2B5Rt9iMRHL1ahyc96q+pdVc76ygLjw7AJnX3BSQLI
 cz8YwldVKoXmi5tOnvh3ox7JCst5EU+Onei2oz7JU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 January 2014, Tanmay Inamdar wrote:
> On Sat, Jan 25, 2014 at 12:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 24 January 2014 13:28:22 Tanmay Inamdar wrote:
> >> On Thu, Jan 16, 2014 at 5:10 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> >> > On Wed, Jan 15, 2014 at 4:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> On Wednesday 15 January 2014, Tanmay Inamdar wrote:
> >> >>
> >> >> Maybe another msleep() in the loop? It seems weird to first do an
> >> >> unconditional sleep but then busy-wait for the result.
> >> >
> >> > ok.
> >>
> >> This loop can execute for maximum 4 msec. So putting msleep(1) won't
> >> get us much.
> >
> > 4 msec is still quite a long time for a busy loop that can be spent doing
> > useful work in another thread.
> >
> 
> Right. If 'msleep(1)' is used, then 'checkpatch' throws a warning
> saying that it can actually sleep for 20ms in some cases. I will check
> if 'usleep_range' is useful here.

Sound good. This is really a false positive from checkpatch though,
with the timeout handling in place, everything's fine even with
msleep(1).

> >> >>
> >> >> Another general note: Your "compatible" strings are rather unspecific.
> >> >> Do you have a version number for this IP block? I suppose that it's related
> >> >> to one that has been used in other chips before, or will be used in future
> >> >> chips, if it's not actually licensed from some other company.
> >> >
> >> > I will have to check this.
> >> >
> >>
> >> We have decided to stick with current compatible string for now.
> >
> > Can you elaborate on your reasoning? Does this mean X-Gene is a one-off
> > product and you won't be doing any new chips based on the same hardware
> > components?
> 
> The current convention is to key upon the family name - X-Gene. Future
> chips will also be a part of X-Gene family. Right now it is unclear if
> there are any obvious feature additions to be done in Linux PCIe
> driver. Until then same driver is expected to work as is in future
> chips.

This is not enough for me. Of course you hope that things keep working,
but experience shows that sometimes hardware has slight differences that
you need to work around later. It's better to always be specific and
at least as a secondary identifier list the exact model of the component,
or if that is not know, the model of the SoC. The driver can bind to
the most generic string, but in DT you should have a specific one as
well.

You could for instance have something like

	compatible = "apm,xgene-1234w78-pcie", "thirdparty,pcie-1.23", "apm,xgene-pcie", "thirdparty,pcie";

as an example where you licensed the pcie block version 1.23 from a company
named thirdparty and integrated it into the xgene variant with product
code 1234w78.

	Arnd
