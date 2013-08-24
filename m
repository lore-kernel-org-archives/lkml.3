Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3HXE6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 00:58:54 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:59944 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab3HXE6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 00:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=Hp/OQS
	gYLp0JUY2faj9hDWx68L1C4uNL1iB3i8h+i6WC0SFw1pybYTPnth44r1/Tk1D7jt
	spNYphhmFisiSg9KbqlypFWtPsyU9hh5UnEhZUkby1X2HopjQaAa4QG4+kNStXgt
	KyGOGPWenZj0jmUJ+Maa1hNTADJf5mO3/EW6k=
Message-ID: <52183D87.40703@pobox.com>
Date: Sat, 24 Aug 2013 13:58:47 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: christian.ruppert@abilis.com
CC: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <20130711101330.GP4898@intel.com> <51DFB6C1.4040001@pobox.com> <20130712085140.GY4898@intel.com> <51E0E76B.1040304@pobox.com> <20130716111616.GA25835@ab42.lan> <51E6ACBE.7000509@pobox.com> <20130722131706.GA24081@ab42.lan> <51EFE550.1000507@pobox.com> <20130805093126.GE20936@ab42.lan> <520D8B30.9000602@pobox.com> <20130821143915.GA3046@ab42.lan>
In-Reply-To: <20130821143915.GA3046@ab42.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: DE3E34F8-0C79-11E3-9AC2-CA9B8506CD1E-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/13 11:39 PM, Christian Ruppert wrote:
> On Fri, Aug 16, 2013 at 11:15:12AM +0900, Shinya Kuribayashi wrote:
>> On 8/5/13 6:31 PM, Christian Ruppert wrote:
>>> On Wed, Jul 24, 2013 at 11:31:44PM +0900, Shinya Kuribayashi wrote:
>>>> As said before, all t_SCL things should go away.  Please forget
>>>> about 100kbps, 400kbps, and so on.  Bus/clock speed is totally
>>>> pointless concept for the I2C bus systems.  For example, as long
>>>> as tr/tf, tHIGH/tLOW, tHD;STA, etc. are met by _all_ devices in a
>>>> certain I2C bus, it doesn't matter that the resulting clock speed
>>>> is, say 120 kbps with Standard-mode, or even 800 kbps for Fast-mode.
>>>> Nobody in the I2C bus doesn't care about actual bus/clock speed.
>>>>
>>>> We don't have to care about the resulting bus speed, or rather
>>>> we should/must not check to see if it's within the proper range.
>>>
>>> Actually, the I2C specification clearly defines f_SCL;max (and thus
>>> implies t_SCL;min), both in the tables and the timing diagrams. Why can
>>> we ignore this constraint while having to meet all the others?
>>
>> If we meet t_r, t_f, t_HIGH, t_LOW (and t_HIGH in this DW case),
>> f_SCL;max will be met by itself.
>
> I'm not sure if I agree with this:
>
> Standard mode:
>         t_r;min          0ns
>         t_f;min     +    0ns
>         t_HIGH;min  + 4000ns
>         t_LOW;min   + 4700ns
>         1/f_SCL     = 8700ns
>     ==> f_SCL       = 115kHz    ==>    violation of f_SCL;max=100kHz
>
> Fast mode (let's assume V_DD = 5.5V):
>         t_r;min         20ns
>         t_f;min     +   20ns
>         t_HIGH;min  +  600ns
>         t_LIW;min   + 1300ns
>         1/f_SCL     = 1940ns
>     ==> f_SCL       = 515kHz    ==>    violation of f_SCL;max=400kHz

It's more realistic to calculate with say 50ns < tr,tf < 300ns,
than with tt = tf = 0ns or <20ns.  Even if with such real tf/tr
times, there is cases where f_SCL can be greater than 100/400Hz.

I understand what you mean, but that was not my point.  See below.

>> And again, all I2C master and
>> slave devices in the bus don't care about f_SCL; what they do care
>> are t_f, t_r, t_HIGH, t_LOW, and so on.  That's why I'm saying
>> f_SCL is pointless and has no value for HCNT/LCNT calculations.
>
> I partially agree: If I2C devices don't care about f_SCL but only about
> t_r, t_f, t_HIGH and t_LOW there's no need to respect the f_SCL;max
> constraint. If this is the case, I'm wondering why it is part of the
> specification, though.

With t_r;max and t_f;max,

Standard mode:
         t_r;max       1000ns (max time applied)
         t_f;max     +  300ns (max time applied)
         t_HIGH;min  + 4000ns
         t_LOW;min   + 4700ns
         1/f_SCL     =10000ns
     ==> f_SCL       = 100kHz    ==> f_SCL;max for Standard-mode

Fast mode:
         t_r;max        300ns (max time applied)
         t_f;max     +  300ns (max time applied)
         t_HIGH;min  +  600ns
         t_LIW;min   + 1300ns
         1/f_SCL     = 2500ns
     ==> f_SCL       = 400kHz    ==> f_SCL;max for Fast-mode

f_SCL;max is defined as a resulting clock frequency with the
combination of:

(1) the max. conditions of t_r and t_f
(2) the min. conditions of t_HIGH and t_LOW

We can try to meet t_HIGH;min and t_LOW;min, but we can't meet
t_r;min nor t_f;min in the actual systems.  The t_r and t_f are
_minimum requisites_ for the I/O buffer characteristic of the
master and the board designs, hence necessarily contain some
time margin.

f_SCL is anything more than the resulting speed of (1) + (2),
so I don't think we need to adjust HCNT/LCNT values at all.
If with t_r < t_r;max and t_f < t_f;max, and you've got a faster
clock speed than f_SCL;max, then it's a bonus and we can accept
it gratefully.

>> I'd make a compromise proposal; it's fine to make sure whether the
>> resulting f_SCL is within a supported range, but should not make a
>> correction of HCNT/LCNT values.  Just report warning messages that
>> some parameters/calculations might be mis-configured an/or wrong.
>
> Not sure if this is a good idea: If f_SCL is met by design I'm perfectly
> happy with dropping the t_HIGH/t_LOW adjustment code, no need to bloat
> the kernel with confusing warnings. If f_SCL is not automatically met we
> must either make sure t_HIGH/t_LOW are adjusted or we must take the
> decision to ignore that constraint and document the reasons behind that
> decision accordingly.

I tried to write my thought down, not sure well-explained, though.

Notes:

* As long as tHD;SDA issue remains in the DW I2C core, we need to
   have t_HIGH with a relatively lager value than necessary.  In
   such a case, the resulting f_SCL can never exceed f_SCL;max.

* I also wonder which values do you think should be adjusted to meet
   f_SCL;max, HCNT or LCNT, and why is that?  I think it's hard to
   explain, isn't it?

   Shinya
