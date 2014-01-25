Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaAYUMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 15:12:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaAYULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:11:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tanmay Inamdar <tinamdar@apm.com>, devicetree@vger.kernel.org,
        Jon Masters <jcm@redhat.com>, linux-doc@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
Date: Sat, 25 Jan 2014 21:11:34 +0100
Message-ID: <5086198.ZOWZ5xuyna@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACoXjc=-JtpiM3m4DSA_DeOxYr3sihGGf4FSaJ2yC08rpm6ANQ@mail.gmail.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com> <CACoXjc=ZT9fEm_KdY4WFSoS8n5FmO+hn9LjsR4m8YZG2iBbt5A@mail.gmail.com> <CACoXjc=-JtpiM3m4DSA_DeOxYr3sihGGf4FSaJ2yC08rpm6ANQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Z74gWE2D0N8G+xvV5LnqHFqCpaT772mr1g2E1ATqLmj
 Ko1umTPdFFvGVPjFcfBey9oYR42LsRCNR0kMchImpaP4QHMY9l
 6Nqg5AMOozXQXYWCTWDQHESrBo8trgy19RlsZqHL63QA5OXD+b
 WzG+DzdkxQhm63SrWfzeUQ2v3RjgI0OHzSDlxpcmNy7aOvV4ur
 qjzmflZSiTm4tMqer97cPKjeJf26cwt2PIphIX0iHVp/U5n/VS
 zEYnA5gghV2vRrfQwYg9EwXO2r9RTi4nezJeeNR9pTjZ+EhUGs
 u0XMEWIw/oR6vtcCAP5kJ3pRbp69aWlE+odryReaUGemQFeVvU
 tI4atlLDowIK8BUhJOTU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 January 2014 13:28:22 Tanmay Inamdar wrote:
> On Thu, Jan 16, 2014 at 5:10 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > On Wed, Jan 15, 2014 at 4:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Wednesday 15 January 2014, Tanmay Inamdar wrote:

> >>
> >>> +static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port, u32 *lanes)
> >>> +{
> >>> +     void *csr_base = port->csr_base;
> >>> +     u32 val32;
> >>> +     u64 start_time, time;
> >>> +
> >>> +     /*
> >>> +      * A component enters the LTSSM Detect state within
> >>> +      * 20ms of the end of fundamental core reset.
> >>> +      */
> >>> +     msleep(XGENE_LTSSM_DETECT_WAIT);
> >>> +     port->link_up = 0;
> >>> +     start_time = jiffies;
> >>> +     do {
> >>> +             val32 = readl(csr_base + PCIECORE_CTLANDSTATUS);
> >>> +             if (val32 & LINK_UP_MASK) {
> >>> +                     port->link_up = 1;
> >>> +                     port->link_speed = PIPE_PHY_RATE_RD(val32);
> >>> +                     val32 = readl(csr_base + BRIDGE_STATUS_0);
> >>> +                     *lanes = val32 >> 26;
> >>> +             }
> >>> +             time = jiffies_to_msecs(jiffies - start_time);
> >>> +     } while ((!port->link_up) || (time <= XGENE_LTSSM_L0_WAIT));
> >>> +}
> >>
> >> Maybe another msleep() in the loop? It seems weird to first do an
> >> unconditional sleep but then busy-wait for the result.
> >
> > ok.
> 
> This loop can execute for maximum 4 msec. So putting msleep(1) won't
> get us much.
 
4 msec is still quite a long time for a busy loop that can be spent doing
useful work in another thread.

> >>
> >> Another general note: Your "compatible" strings are rather unspecific.
> >> Do you have a version number for this IP block? I suppose that it's related
> >> to one that has been used in other chips before, or will be used in future
> >> chips, if it's not actually licensed from some other company.
> >
> > I will have to check this.
> >
> 
> We have decided to stick with current compatible string for now.

Can you elaborate on your reasoning? Does this mean X-Gene is a one-off
product and you won't be doing any new chips based on the same hardware
components?

	Arnd
