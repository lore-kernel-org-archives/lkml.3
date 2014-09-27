Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaI0MNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 08:13:41 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:33918 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaI0MNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 08:13:39 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 08:13:39 EDT
Date: Sat, 27 Sep 2014 15:06:49 +0300
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <cyndis@kapsi.fi>, edubezval@gmail.com,
        swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v6 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
Message-ID: <20140927120649.GA70809@sandfort.unics.fi>
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi>
 <1411724593-4037-5-git-send-email-cyndis@kapsi.fi>
 <20140926114533.GN31106@ulmo>
 <5425CC6F.2020309@kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5425CC6F.2020309@kapsi.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:28:31PM +0300, Mikko Perttunen wrote:
> > I think a more idiomatic way to write this would be:
> >
> > static int
> > calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
> >                               struct tsensor_shared_calibration shared,
> >                               u32 *calib)
[snip]
> >
> > While at it, perhaps make shared a const * instead of passing it in by
> > value?
> 
> That is possible, but I'm not sure what the difference would be. Is 
> there a style rule forbidding by-value compound types? (Also if I change 
> the style, it would go over 80 characters by even more.)

I guess the idea is that it's more space- and time-efficient to pass
compound types as pointers instead of by value. Kernel stack is quite
limited in size, so allocating structs from stack in this way quickly
eats up the stack. Furthermore, there's less machine language
instructions in the function call if passed as a pointer, because when
passed as a value, each member of the struct needs to be pushed to the
stack separately (unless the member size is smaller than word length of
the machine architecture, in which case the compiler may optimize a
bit). So it's faster, too, to pass by pointer. In the case of kernel
coding, of these problems the limited stack size is far more serious.

In this case, however, the current struct is only 16 bytes vs 4/8 bytes
for a pointer, so it shouldn't matter that much. But IMO as a general
rule it's a far better style to pass compound types as pointers. I would
definitely pass by pointer here instead of passing by value even given
that the advantages in this particular case are limited. You should
consider the possibility that in a future driver version struct
tsensor_shared_calibration may become larger, and thus the code will be
closer to stack overflow if the one who increases the size of struct
tsensor_shared_calibration doesn't notice that it is passed by value.

There are always ways to structure the code so that it looks fine and
the additional "const *" will not cause the line length to become >80
chars. In my opinion, line length considerations should never play a
role on deciding whether to pass by value or pass by pointer. I don't
understand why you think this particular function would have line length
problems. In my opinion, the following is 78 chars max:

static int 
calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
                              const struct tsensor_shared_calibration *shared,
                              u32 *calib)

Of course, if you want to have "static int" on the same line as the
function name, then you'll have problems but even those can be avoided
so that the code still looks fine:

static int calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
                                         const struct
                                             tsensor_shared_calibration *shared,
                                         u32 *calib)

Anyway, the root cause of line length problems here is overlong
identifiers. For example, "calculate_tsensor_calibration" is in my
opinion too long for a function name. You could easily abbreviate it to
"calc_tsensor_calib" without losing any information. Similarly, "struct
tsensor_shared_calibration" could be easily abbreviated to "struct
tsensor_shared_calib". Then you could have easily:

static int calc_tsensor_calib(const struct tegra_tsensor *sensor,
                              const struct tsensor_shared_calib *shared,
                              u32 *calib)

without being even close to the 80-character line length limitation.
