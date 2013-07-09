Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3GIVts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:49:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3GIVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:49:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas.kandagatla@st.com
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
Date: Tue, 9 Jul 2013 23:15:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com> <201307090956.03191.arnd@arndb.de> <51DBE718.2080007@st.com>
In-Reply-To: <51DBE718.2080007@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307092315.06131.arnd@arndb.de>
X-Provags-ID: V02:K0:LjUzf2prJtYWOuK/enkZrPfAQj7RVb1VshiJCowhPaj
 8OCBfGrLsd2bGISjXGtd6zKXILlh5iCIxvORMAw/WMrmDUrfDn
 1dJI0NSpiTWMC7osIVfJMTXE/+J7RBxbIIwDVQKRwS2TyMwYWo
 F3BUfLtM1QREKJtj6NL4YjG1k2Fz6zXgbPhhUt+ivtblcktUbP
 R5twqQzlN5ZQmN40rdQoR6stEzksNZ6NsXjRv/vI6HNekc3lGH
 DwZyTu17QW0dD1J+Tya8GV6EdDYHrT+id/qIok2TghnhVLBhVt
 +yp6yyGSZ7MlfFYQPqaKl6cc2ChvdI49HfLBEJXEwVFC//mgXi
 UcepPLy1K24J/oyNXS7A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 July 2013, Srinivas KANDAGATLA wrote:
> On 09/07/13 08:56, Arnd Bergmann wrote:
> > No, you should be using generic interfaces to do the things you need.
> > 
> > I believe what you are missing is an ethernet phy driver that is specific
> > to your SoC.
> It looks interesting way to solve the issue.
> 
> Did you mean "Ethernet PHY"?
> 
> Ethernet PHY is not integrated in the STiH41x SoC, We use an external
> ICPLUS phy ( drivers/net/phy/icplus.c) for both B2000 and B2020 boards.
> As we can't have  two Ethernet phy drivers at the same time, I think the
> suggestion might not work in this case.
> 
> The callbacks in the mach level are setting up two SOC specific System
> Configuration registers which configures the MAC (like PHY interface
> selection, which is sampled during MAC reset assertion).

Ah, right.

> MAC used in STiH41x supports multiple PHY interfaces, so the PHY
> interface selection is driven by external signals wired up to System
> Configuration registers. The MAC driver is not aware of these System
> Configuration registers. So for non-DT case, stmmac driver provided
> callbacks to do things like this.
> 
> For DT case, At the moment I think callbacks at MACH level is one
> possible solution. But am open for any discussions.

Ok, so a PHY driver might not be the best place to put this, but it's
one option, since the PHY driver already has to know about the
interface speed you are setting.

Having a global "*_setup_ethernet" callback is definitely not the
right way to go. Please describe what the function actually does
so we can come up with the right subsystem to move that functionality
to. If you are setting clocks, you should use the clock subsystem,
for taking the device out of reset, you should use the reset controller
subsystem and for setting up the phy, you should use the phy subsystem,
etc.

	Arnd
