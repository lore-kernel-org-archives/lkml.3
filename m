Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3KYVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:19:47 -0500
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:37195 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083Ab3KYVTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:19:44 -0500
X-Greylist: delayed 2400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 16:19:44 EST
Message-ID: <5293ACA6.7060403@bracey.fi>
Date: Mon, 25 Nov 2013 22:01:42 +0200
From: Kevin Bracey <kevin@bracey.fi>
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com> <528BB1F2.4080107@wwwdotorg.org> <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com> <528BB913.6080409@wwwdotorg.org> <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com> <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
In-Reply-To: <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12454986245928554717
X-Ovh-Remote: 62.183.157.30 (62-183-157-30.bb.dnainternet.fi)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/2013 16:34, Linus Walleij wrote:
> On Wed, Nov 20, 2013 at 1:02 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Wed, Nov 20, 2013 at 4:16 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> I think that last point should be addressed by having a driver that owns
>>> the GPIO set it to the desired output level, and the implementation of
>> Some pins are not connected (NC). At that cases, there's no drivers to
>> handle it. To reduce power leakage, it sets proper configuration with
>> values instead of reset values.
> This is correspondant to the PIN_CONFIG_OUTPUT from
> include/linux/pinctrl/pinconf-generic.h

Indeed it is - I was waiting for someone to point that out. Now we've 
got there...

I've been working on extending the shmobile PFC driver to provide 
"gpio-mode" and implement PIN_CONFIG_OUTPUT as described by 
Documentation/pinctrl.txt, primarily to handle sleep states, but I have 
begun to wonder about the initial state problem, as discussed here.

As far as I can see, we can't currently specify "fallback" states for 
pins, which is one of Tomasz' key requirements.

We can specify "hog" states, and we can specify "default for a driver", 
but not "default before/in absence of a driver" or "sleep in absence of 
a driver". Having a hog precludes any finer driver control, AFAICT.

Some of our existing pre-pinconf board files have a "unused pins" table 
which is used to claim and pull GPIOs. I've converted that to "hog" 
pinconf, but that only works because the table omits all pins used by 
drivers. And, unsurprisingly, that's been error-prone; if those tables 
originally covered all unused pins, they don't any more.

I'd like confidence that we can get every pin into the correct state by 
having a fully-populated table containing all pins, that can be used 
regardless of which drivers start. I think what we're lacking is a "weak 
hog". Whatever you call that. :)

That would also specify the state to fallback to when a group is 
released (where we currently do pinmux_disable_setting).

Thoughts?

Kevin


