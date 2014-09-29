Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaI2NnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:43:01 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:46306 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaI2Nm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:42:59 -0400
Message-ID: <542961DD.5000003@kapsi.fi>
Date: Mon, 29 Sep 2014 16:42:53 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <cyndis@kapsi.fi>, edubezval@gmail.com,
        swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v6 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi> <1411724593-4037-5-git-send-email-cyndis@kapsi.fi> <20140926114533.GN31106@ulmo> <5425CC6F.2020309@kapsi.fi> <20140927120649.GA70809@sandfort.unics.fi>
In-Reply-To: <20140927120649.GA70809@sandfort.unics.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2014 03:06 PM, Juha-Matti Tilli wrote:
> On Fri, Sep 26, 2014 at 11:28:31PM +0300, Mikko Perttunen wrote:
>>> I think a more idiomatic way to write this would be:
>>>
>>> static int
>>> calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
>>>                                struct tsensor_shared_calibration shared,
>>>                                u32 *calib)
> [snip]
>>>
>>> While at it, perhaps make shared a const * instead of passing it in by
>>> value?
>>
>> That is possible, but I'm not sure what the difference would be. Is
>> there a style rule forbidding by-value compound types? (Also if I change
>> the style, it would go over 80 characters by even more.)
>
> I guess the idea is that it's more space- and time-efficient to pass
> compound types as pointers instead of by value. Kernel stack is quite
> limited in size, so allocating structs from stack in this way quickly
> eats up the stack. Furthermore, there's less machine language
> instructions in the function call if passed as a pointer, because when
> passed as a value, each member of the struct needs to be pushed to the
> stack separately (unless the member size is smaller than word length of
> the machine architecture, in which case the compiler may optimize a
> bit). So it's faster, too, to pass by pointer. In the case of kernel
> coding, of these problems the limited stack size is far more serious.

I can accept that saving kernel stack space is a good reason to use 
pointers. And since as you below mentioned, there is no line length 
issue, I'll change this.

>
> In this case, however, the current struct is only 16 bytes vs 4/8 bytes
> for a pointer, so it shouldn't matter that much. But IMO as a general
> rule it's a far better style to pass compound types as pointers. I would
> definitely pass by pointer here instead of passing by value even given
> that the advantages in this particular case are limited. You should
> consider the possibility that in a future driver version struct
> tsensor_shared_calibration may become larger, and thus the code will be
> closer to stack overflow if the one who increases the size of struct
> tsensor_shared_calibration doesn't notice that it is passed by value.
>
> There are always ways to structure the code so that it looks fine and
> the additional "const *" will not cause the line length to become >80
> chars. In my opinion, line length considerations should never play a
> role on deciding whether to pass by value or pass by pointer. I don't
> understand why you think this particular function would have line length
> problems. In my opinion, the following is 78 chars max:
>
> static int
> calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
>                                const struct tsensor_shared_calibration *shared,
>                                u32 *calib)

Good point. I usually never use this style, so I didn't think of doing 
it like that. But it is clearly the best solution.

>
> Of course, if you want to have "static int" on the same line as the
> function name, then you'll have problems but even those can be avoided
> so that the code still looks fine:
>
> static int calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
>                                           const struct
>                                               tsensor_shared_calibration *shared,
>                                           u32 *calib)
>
> Anyway, the root cause of line length problems here is overlong
> identifiers. For example, "calculate_tsensor_calibration" is in my
> opinion too long for a function name. You could easily abbreviate it to
> "calc_tsensor_calib" without losing any information. Similarly, "struct
> tsensor_shared_calibration" could be easily abbreviated to "struct
> tsensor_shared_calib". Then you could have easily:
>
> static int calc_tsensor_calib(const struct tegra_tsensor *sensor,
>                                const struct tsensor_shared_calib *shared,
>                                u32 *calib)
>
> without being even close to the 80-character line length limitation.

Yes, might be.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Mikko

