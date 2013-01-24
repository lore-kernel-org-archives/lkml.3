Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3AXJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:53:18 -0500
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1129 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752939Ab3AXJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:53:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4374
Message-ID: <510104BD.2020500@metafoo.de>
Date: Thu, 24 Jan 2013 10:54:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <1358917086-4148-1-git-send-email-ch.naveen@samsung.com> <50FFDD2A.9040102@metafoo.de> <CAD=FV=VgrpPSLrwwrzFDFLBXTw+-t3C=UwnS6b53o41hxM_AyQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VgrpPSLrwwrzFDFLBXTw+-t3C=UwnS6b53o41hxM_AyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 01:42 AM, Doug Anderson wrote:
> Lars,
> 
> On Wed, Jan 23, 2013 at 4:52 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> Few doubts regarding the mappings and child device handling.
>>> Kindly, suggest me better methods.
>>
>> The patch looks mostly good now. As for the mappings, the problem is that we
>> currently do not have any device tree bindings for IIO. So a proper solution
>> would be to add dt bindings for IIO.
> 
> Can you explain more how you think this would work?  It seems like
> just having child nodes as platform drivers would be OK (to me) and
> having them instantiated with of_platform_populate() seems reasonable.
> 
> ...but the one thing that is missing is a way for children to get
> access to the channel properly.
> 
> The children have access to the ADC "struct device" (it is their
> parent device) and have a channel number (their "reg" field), but
> there is no API call to map this to a "struct iio_channel".  Is that
> all that's needed in this case?  ...or are you envisioning something
> more?

Well, the idea is that the consumer doesn't need to know the channel number.
That's what the mapping takes care of. It basically creates a consumer alias
for the channel. When requesting the channel the consumer always uses the
same name.

iio_channel_get(dev_name(&pdev->dev), "voltage");

And the mapping contains an entry which maps the tuple of device name and
channel name to a real IIO channel which as been registered by a IIO device.
Note if there is only one channel you can also just use NULL for the channel
name. This is similar to how clocks are managed with the clk framework.

Now for the dt bindings I think we should stick to something similar to what
the clk framework does.

E.g.

adc: adc@12D10000 {

	#io-channel-cells = <1>;
	io-channel-output-names = "adc1", "adc2", ...;

	ncp15wb473@0 {
		compatible = "ntc,ncp15wb473";
		...
		io-channels = <&adc 0>; // First ADC channel
		io-channel-names = "voltage";
	};

	ncp15wb473@0 {
		compatible = "ntc,ncp15wb473";
		...
		io-channels = <&adc 1>; // Second ADC channel
		io-channel-names = "voltage";
	}
};

io-channel-output-names and io-channel-names can be optional. In the case
where there is only one channel it's not really necessary to use
io-channel-names.

- Lars
