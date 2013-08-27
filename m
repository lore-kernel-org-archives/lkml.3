Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3H0GGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:06:30 -0400
Received: from 6.mo1.mail-out.ovh.net ([46.105.43.205]:37659 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752002Ab3H0GG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:28 -0400
Message-ID: <521C4177.4030104@overkiz.com>
Date: Tue, 27 Aug 2013 08:04:39 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 2/3] pinctrl: at91: add support for generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380259-11290-1-git-send-email-b.brezillon@overkiz.com> <20130826175333.GF18627@ns203013.ovh.net> <521BA235.1090104@overkiz.com> <521C22EA.1050908@wwwdotorg.org>
In-Reply-To: <521C22EA.1050908@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4719772410877016141
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 05:54, Stephen Warren wrote:
> On 08/26/2013 12:45 PM, boris brezillon wrote:
>> Hello Jean-Christophe,
>>
>> Le 26/08/2013 19:53, Jean-Christophe PLAGNIOL-VILLARD a écrit :
>>> On 23:37 Sat 24 Aug     , Boris BREZILLON wrote:
>>>> Add support for generic pin configuration to pinctrl-at91 driver.
> ...
>>>> a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> ...
>>>> configures various pad settings
>>>>    such as pull-up, multi drive, etc.
>>>>      Required properties for iomux controller:
>>>> -- compatible: "atmel,at91rm9200-pinctrl"
>>>> +- compatible: "atmel,at91rm9200-pinctrl" or "atmel,at91sam9x5-pinctrl".
>>>> +  Add "generic-pinconf" to the compatible string list to use the
>>>> generic pin
> ...
>>>> +pinctrl@fffff400 {
>>>> +    #address-cells = <1>;
>>>> +    #size-cells = <1>;
>>>> +    ranges;
>>>> +    compatible = "atmel,at91rm9200-pinctrl", "generic-pinconf",
>>>> "simple-bus";
>>> nack your break the backword compatibility
>>>
>>> if we use a old kernel with this new dt nothing will work
>>> as the old kernel will never known the the "generic-pinconf" means
>>> anything
>> Your're right, I didn't think of this case (old kernel with new dt).
> Well, just to be clear: If a new DT uses a new compatible value of any
> kind, be it adding "generic-pinconf" or switching to "foo-yyy" rather
> than "foo-yyy", it won't be compatible... That somewhat implies that you
> can't ever replace an old binding with something new.

That's absolutely right, however the behaviour won't be the same in both 
cases.

1) If your (new) dt defines its pinctrl using the "foo-pinconf" 
compatible string and
     your (old) kernel does not support it, the pinctrl will never probe 
the pinctrl definitions.
     Moreover, if you want to define both old ("foo-pinctrl") and new 
("foo-pinconf") pinctrl
     definitions in your dt in order to support several kernel versions, 
nothing prevents you
     from doing it.

2) In the other hand, if you use an additional "generic-pinconf" 
compatible string to signify
     wether or not the pinctrl definition use the generic pinconf dt 
binding, the (old) kernel
     will probe the pinctrl definitions, ignore the "generic-pinconf" 
string, and fail when parsing
     the pinctrl configuration nodes (which are invalid pinctrl function 
nodes in the current dt binding).
     We have the same problem when using the 'atmel,generic-pinconf' 
property inside a pinctrl node:
     old kernels won't take this property into account.

