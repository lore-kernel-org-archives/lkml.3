Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaFXJjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:39:35 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57928 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaFXJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:39:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the MiPHY365x
Date: Tue, 24 Jun 2014 11:38:54 +0200
Message-ID: <6599289.0ZjjaMbRqj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140618100411.GL23945@lee--X1>
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org> <53A160D1.8000908@ti.com> <20140618100411.GL23945@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:P4kRwgmfKiOrqeyGUdOC1EOaQ7gNxRgDCUCPKM+Fw9V
 NYK0jEP9aSUNNH0caht6rPwrkEDQbZ6zXxiMMAji+LoLFP3WYg
 awDv0Tz43qT8hU+NdD8dHHy3DLtitYvrUED/yXEx98NEKRE04n
 ftnj1LvTsaGSIGS39x6yyDrmi1O+iEx2wBPPukRcm1Lv8lNfLA
 gwLhoCIqUFv3V3kDOJGuedPBmMKXiNFkiXTxFayZ7LcXTmkJI5
 NdEBwouEAnUOAlQnQy0s1XfxsLtj/MF1nApaeUgQtJyeq6eBW+
 gy12ieYTdgfcOuwVfm/hekg3QWCTJQmguNpbPycW42UPoEPxeC
 Xu2sylEchOuhNE41umFs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2014 11:04:11 Lee Jones wrote:
> > On Tuesday 17 June 2014 04:53 PM, Lee Jones wrote:
> > >>> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> > >>> devices. It has 2 ports which it can use for either; both SATA, both
> > >>> PCIe or one of each in any configuration.
> > >>
> > >> I've asked others who wrote multi-phy PHY providers to model each individual
> > >> PHY as sub-node of the PHY provider. So It's only fair I ask you the same to
> > >> do. So in this case the dt node should look something like:
> > >>
> > >> 	miphy365x_phy: miphy365x@fe382000 {
> > >> 		compatible = "st,miphy365x-phy";
> > >> 		#phy-cells = <2>;
> > >> 		st,syscfg = <&syscfg_rear>;
> > >> 		channel@0 {
> > >> 			reg =	<0xfe382000 0x100>, <0xfe394000 0x100>;
> > >> 			reg-names = "sata", "pcie";
> > >> 		}
> > >>
> > >> 		channel@1{
> > >> 			reg =	<0xfe38a000 0x100>, <0xfe804000 0x100>;
> > >> 			reg-names = "sata", "pcie";
> > >> 		}
> > >>
> > >> 	};
> > > 
> > > I'm interested to know why you've taken this approach, as it makes the
> > > code much more complex.  The DT framework goes to the trouble of
> > 
> > It looks to be much closer representation of the hardware in dt. It also
> > enables to have more control of each individual PHYs. For example, we can have
> > something like status="disabled" for channels which is disabled.
> 
> If you wanted to disable the channels in this way, you would either
> have to A) add your own code to parse that property or B) have each
> channel set itself up as platform device and would probe (or not if
> status = "disabled") individually.  If you choose the later option,
> the platform resource would also be populated.

We have of_device_is_available() and for_each_available_child_of_node()
to check for the status property. This doesn't seem much extra overhead.

> > > converting all addresses to to resources so drivers can easily pull
> > > them out using platform_get_resource() and friends.  Pushing the reg
> > 
> > right. Can't we use of_address_to_resource here?
> 
> We could, but that would be an extra layer.  We'd be pulling the
> address, putting it into a resource, then pulling it from the resource
> for use.  If we're going to be pulling addresses out manually, we're
> probably better off using of_get_address().  But again, we're just
> carrying out functionality which is already provided by the
> framework.

there is also of_ioremap().

> > > properties down into a child node means that we have to now iterate
> > > over the sub-nodes and pull them out manually.  This will lead to a
> > 
> > You anyway iterate while creating PHYs based on some constant. Now you have to
> > iterate over the sub-nodes.
> > > pretty messy implementation IMHO.
> 
> This much is true.
> 
> > > Can you point me in the direction of previous implementations where you
> > > have stipulated the same set of constraints please?
> > 
> > ah.. there isn't any. The author of the other multi-phy driver [1] also feels
> > this will just add to the complexity of the driver.
> 
> =:)
> 
> > Maybe we should ask the opinion of others?
> 
> We could.  I'll CC Arnd as he likes this PHY stuff. :)
> 
> > [1] -> http://www.spinics.net/lists/linux-sh/msg32087.html

Having sub-nodes for each individual PHY managed by a controller seems
very reasonable to me. Making them show up as separate platform devices
seems less useful though.

	Arnd
