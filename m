Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3HUOre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:47:34 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26174 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab3HUOnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:07 -0400
Date: Wed, 21 Aug 2013 16:39:17 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: mika.westerberg@linux.intel.com, linux-i2c@vger.kernel.org,
        wsa@the-dreams.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
Message-ID: <20130821143915.GA3046@ab42.lan>
References: <20130711101330.GP4898@intel.com>
 <51DFB6C1.4040001@pobox.com>
 <20130712085140.GY4898@intel.com>
 <51E0E76B.1040304@pobox.com>
 <20130716111616.GA25835@ab42.lan>
 <51E6ACBE.7000509@pobox.com>
 <20130722131706.GA24081@ab42.lan>
 <51EFE550.1000507@pobox.com>
 <20130805093126.GE20936@ab42.lan>
 <520D8B30.9000602@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <520D8B30.9000602@pobox.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:15:12AM +0900, Shinya Kuribayashi wrote:
> Hi,
> 
> On 8/5/13 6:31 PM, Christian Ruppert wrote:> On Wed, Jul 24, 2013 at 11:31:44PM +0900, Shinya Kuribayashi wrote:
> >>As said before, all t_SCL things should go away.  Please forget
> >>about 100kbps, 400kbps, and so on.  Bus/clock speed is totally
> >>pointless concept for the I2C bus systems.  For example, as long
> >>as tr/tf, tHIGH/tLOW, tHD;STA, etc. are met by _all_ devices in a
> >>certain I2C bus, it doesn't matter that the resulting clock speed
> >>is, say 120 kbps with Standard-mode, or even 800 kbps for Fast-mode.
> >>Nobody in the I2C bus doesn't care about actual bus/clock speed.
> >>
> >>We don't have to care about the resulting bus speed, or rather
> >>we should/must not check to see if it's within the proper range.
> >
> >Actually, the I2C specification clearly defines f_SCL;max (and thus
> >implies t_SCL;min), both in the tables and the timing diagrams. Why can
> >we ignore this constraint while having to meet all the others?
> 
> If we meet t_r, t_f, t_HIGH, t_LOW (and t_HIGH in this DW case),
> f_SCL;max will be met by itself.

I'm not sure if I agree with this:

Standard mode:
       t_r;min          0ns
       t_f;min     +    0ns
       t_HIGH;min  + 4000ns
       t_LOW;min   + 4700ns
       1/f_SCL     = 8700ns
   ==> f_SCL       = 115kHz    ==>    violation of f_SCL;max=100kHz

Fast mode (let's assume V_DD = 5.5V):
       t_r;min         20ns
       t_f;min     +   20ns
       t_HIGH;min  +  600ns
       t_LIW;min   + 1300ns
       1/f_SCL     = 1940ns
   ==> f_SCL       = 515kHz    ==>    violation of f_SCL;max=400kHz

In my understanding, f_SCL;max condition is only met
a) either if t_HIGH = t_HIGH;min and t_LOW = t_LOW;min
          then t_r must be t_r;max and t_f must be t_f;max
b) or if t_r < t_r;max and t_f < t_f;max 
      then t_HIGH must be > t_HIGH;min and T_LOW must be T_LOW;min

Given that we cannot easily influence t_r and t_f we must adjust t_HIGH
and t_LOW. What am I missing here?

> And again, all I2C master and
> slave devices in the bus don't care about f_SCL; what they do care
> are t_f, t_r, t_HIGH, t_LOW, and so on.  That's why I'm saying
> f_SCL is pointless and has no value for HCNT/LCNT calculations.

I partially agree: If I2C devices don't care about f_SCL but only about
t_r, t_f, t_HIGH and t_LOW there's no need to respect the f_SCL;max
constraint. If this is the case, I'm wondering why it is part of the
specification, though.

> Is that clear?  What is the point to make sure whether f_SCL
> constraint is met or not?  Is there any combination where t_f,
> t_r, t_HIGH, t_LOW, t_HD;SATA are met, but f_SCL is out of range?
> I don't think there is.

See above.

> I'd make a compromise proposal; it's fine to make sure whether the
> resulting f_SCL is within a supported range, but should not make a
> correction of HCNT/LCNT values.  Just report warning messages that
> some parameters/calculations might be mis-configured an/or wrong.

Not sure if this is a good idea: If f_SCL is met by design I'm perfectly
happy with dropping the t_HIGH/t_LOW adjustment code, no need to bloat
the kernel with confusing warnings. If f_SCL is not automatically met we
must either make sure t_HIGH/t_LOW are adjusted or we must take the
decision to ignore that constraint and document the reasons behind that
decision accordingly.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
