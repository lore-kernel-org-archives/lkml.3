Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbaE3Tyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:54:55 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:65231 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaE3Tyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] devicetree: Add generic IOMMU device tree bindings
Date: Fri, 30 May 2014 21:54:37 +0200
Message-ID: <4462924.8iRbdkOPp7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <87tx87rrp2.fsf@nvidia.com>
References: <1400877218-4113-1-git-send-email-thierry.reding@gmail.com> <4545972.cM7IP1qTXQ@wuerfel> <87tx87rrp2.fsf@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:H5r2Gwa0A1MwpkhE6Ck6wUn/WcLjP7HBGGNIUPIn7Bq
 qGoIzytQUz+3F+5A8A8Yp63u3DiioJXa7NIUM3gPu7Y7o9KqOQ
 Al6wRYNnsdtHpyncg3Oeah3Y43oy6MV3Sra+pIYDD8SOqQJ2y+
 g+ZZFfgEoG96KVVAmZzQWpi1brziVmwDiRx+lenH3O/qRz8bOq
 vTKRyv53n4Gx8YHBQxaEFLABJYKOC/UY+n3bMwMgUL8NTedUhL
 F6Zn1HqDASa/hBxdqLdxlFrRx0dle/U9XC/DAP1qMUo9yR9WR0
 D/fFcMZLQVZZzPx6kOVzi5NETHQa809NUzF5en6L6H02ZJ7dI/
 k8go3syH4SW5hERRAwOs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2014 22:29:13 Hiroshi Doyu wrote:
> 
> IIUC the original problem, "a master with 8 streamIDs" means something
> like below, where some devices have multiple IDs but some have a
> single. A sinle #address-cells cannot afford those 2 masters at once.
> 
>        iommu {
>                /* the specifier represents the ID of the master */
>                #address-cells = <1>;
>                #size-cells = <0>;
>        };
> 
>         master@a {
>                 ...
>                 iommus = <&smmu 1 2 3>; # 3 IDs
>         };
> 
>         master@b {
>                 ...
>                 iommus = <&smmu 4>;     # 1 ID
>         };

This would not be the usual format really. It should instead be

		iommus = <&smmu 1>, <&smmu 2>, <&smmu 3>;

which can be tedious to type.

> Tegra,SMMU has a similar problem and we have used a fixed size bitmap(64
> bit) to afford 64 stream IDs so that a single device can hold multiple
> IDs. If we apply the same bitmap to the above exmaple:
> 
>        iommu {
>                /* the specifier represents the ID of the master */
>                #address-cells = <1>;
>                #size-cells = <0>;
>        };
> 
>         master@a {
>                 ...
>                 iommus = <&smmu (BIT(1) | BIT(2) | BIT(3))>; # IDs 1 2 3
>         };
> 
>         master@b {
>                 ...
>                 iommus = <&smmu BIT(4)>;     # ID 4
>         };
> 
> The disadvantage of this is that this limits the max number of streamIDs
> to support. If # of streamID is increased later more than 64, this
> format cannot cover any more. You have to predict the max # of streamIDs
> in advance if steamID is statically assigned.
> 

Well, the iommu specific binding could allow a variable #address-cells.
That way, you just need to know the number of stream IDs for that instance
of the iommu.

	Arnd
