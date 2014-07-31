Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbaGaNgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:36:50 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:5761
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750702AbaGaNgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:36:47 -0400
Date: Thu, 31 Jul 2014 15:36:35 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Michal Simek <michal.simek@xilinx.com>
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Punnaiah Choudary <kpc528@gmail.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Srikanth Vemula <svemula@xilinx.com>
Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
References: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
 <20140731113324.GB4375@pd.tnic>
 <808655a9-77eb-4e3a-9781-2b059ad9517b@BN1AFFO11FD020.protection.gbl>
 <20140731131702.GC4375@pd.tnic>
In-Reply-To: <20140731131702.GC4375@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <a366b39c-b354-4d90-8b1e-71e74ab77cf3@BL2FFO11FD011.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(164054003)(51704005)(189002)(199002)(377454003)(479174003)(81542001)(74502001)(87936001)(95666004)(83506001)(76482001)(83072002)(85306003)(85852003)(92566001)(21056001)(31966008)(106466001)(4396001)(65956001)(1496007)(64706001)(44976005)(65806001)(6806004)(50466002)(81342001)(46102001)(76176999)(80022001)(70736001)(83322001)(92726001)(93886003)(54356999)(102836001)(107046002)(86362001)(50986999)(79102001)(77982001)(74662001)(104016003)(74316001)(31696002)(47776003)(20776003)(65826006)(107986001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB059;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:3;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0289B6431E
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 03:17 PM, Borislav Petkov wrote:
> On Thu, Jul 31, 2014 at 02:13:48PM +0200, Michal Simek wrote:
>> Mixing two drivers in the one file is not a good idea because with
>> more memory controllers it is just a mess and you are not able to
>> cover all cases.
> 
> Why is it a mess?

Mixing functions for two/more different controller seems to me
really messy. Also having that drivers separated is useful if
driver probe fails for one controller (you can write the code for it
but it won't be nice).

>> If this is just about providing uniq number we can easily extend
>> binding and provide that uniq value. That's remind me solution with
>> edac_mc_get_id() can caused that you won't have exact number all the
>> time - depends on driver loading (deferred probing too).
> 
> -ENOPARSE for this sentence.

I meant by this this scenario - please correct me if I am completely wrong
because I am not playing with this subsystem. My expectation is that
memory controller number should be same all the time.

two memory controllers with the same edac driver.

Normal calling sequence:
X probe - number 0
Y probe - number 1

Different order/name (I think order is taken at the first place)
in DTS should caused that X will have number 1 and Y number 0.

Another scenario:
two controllers and one with external gpio reset for example.

X probe is called but gpio controller is not ready and gpio driver returns
-EPROBE_DEFER then Y probe is called and get number 0. Then X probe is called
again and get number 1.


>> One option via DT can be via aliases where you can easily specify
>> order. But all of these issues can be solved in follow-up patch.
> 
> Whatever you do, it should be designed cleanly and not introduce some
> homegrown solution.

Definitely I 100% agree with you. That's why I think this should
be solved separately.

Thanks,
Michal


