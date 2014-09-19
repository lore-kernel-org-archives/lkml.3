Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbaISJyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:54:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:17388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbaISJyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="575617509"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "rayagond@vayavyalabs.com" <rayagond@vayavyalabs.com>
CC: Vince Bridgers <vbridgers2013@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Subject: RE: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Topic: [PATCH] net: stmmac: fix stmmac_pci_probe failed when
 CONFIG_HAVE_CLK is selected
Thread-Index: AQHP00/RkjkXc0yE00eOiNSPpFLLQpwHkbsg
Date: Fri, 19 Sep 2014 09:52:21 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7EA4B1@PGSMSX102.gar.corp.intel.com>
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
 <541AF116.9010004@st.com>
In-Reply-To: <541AF116.9010004@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Giuseppe CAVALLARO [mailto:peppe.cavallaro@st.com]
> Sent: Thursday, September 18, 2014 10:50 PM
> On 9/18/2014 2:34 PM, Kweh Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Hmm I am not sure this is the right fix. The driver has to fail if the main clock is
> not found. Indeed dev_warn has to be changed in dev_err.
> 
> Take a look at Documentation/networking/stmmac.txt but I will post some
> patch to improve the documentation adding further detail for clocks too.
> 
> The the logic behind the code is that the CSR clock will be set at runtime if in
> case of priv->plat->clk_csr ==0 or it will be forced to a fixed value if passed
> from the platform instead of.
> IIRC This was required on some platforms time ago.
> For sure the driver is designed to fail in case of no main clock is found.
> 
> Peppe

Hi Peppe,

I understand your point from the code below (at file stmmac_main.c line 2784):

/* If a specific clk_csr value is passed from the platform
  * this means that the CSR Clock Range selection cannot be
  * changed at run-time and it is fixed. Viceversa the driver'll try to
  * set the MDC clock dynamically according to the csr actual
  * clock input.
  */
if (!priv->plat->clk_csr)
        stmmac_clk_csr_set(priv);
else
        priv->clk_csr = priv->plat->clk_csr;


I did search through the whole stmmac_main.c file and found that only stmmac_clk_csr_set()
function is leveraging the priv->stmmac_clk params for it calculation. By the logic point of
view, I do not need priv->stmmac_clk when I got priv->plat->clk_csr. With this thinking,
I propose this fix as when the probe get priv->plat->clk_csr, it shouldn't fail if priv->stmmac_clk
has the error value.


Regards,
Wilson

