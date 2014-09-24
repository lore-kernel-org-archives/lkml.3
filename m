Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaIXMem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:34:42 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65086 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaIXMeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140924122658.GD17019@localhost>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
	<1411414759-7056-2-git-send-email-octavian.purdila@intel.com>
	<20140924101206.GD19999@lee--X1>
	<20140924102853.GA17019@localhost>
	<20140924120002.GA32069@lee--X1>
	<20140924122658.GD17019@localhost>
Date: Wed, 24 Sep 2014 15:34:08 +0300
Message-ID: <CAE1zotLx-mB=rejxA9JwtWRwdYWinC82AXwtsczgQXFOSLMdrA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mfd: viperboard: allocate I/O buffer separately
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 3:26 PM, Johan Hovold <johan@kernel.org> wrote:
> On Wed, Sep 24, 2014 at 01:00:02PM +0100, Lee Jones wrote:
>> On Wed, 24 Sep 2014, Johan Hovold wrote:
>>
>> > On Wed, Sep 24, 2014 at 11:12:06AM +0100, Lee Jones wrote:
>> > > On Mon, 22 Sep 2014, Octavian Purdila wrote:
>> > >
>> > > > Currently the I/O buffer is allocated part of the device status
>> > > > structure, potentially sharing the same cache line with other members
>> > > > in this structure.
>> > > >
>> > > > Allocate the buffer separately, to avoid the I/O operations corrupting
>> > > > the device status structure due to cache line sharing.
>> > > >
>> > > > Compiled tested only as I don't have access to hardware.
>> > > >
>> > > > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>> > > > ---
>> > > >  drivers/mfd/viperboard.c       | 8 ++++++++
>> > > >  include/linux/mfd/viperboard.h | 2 +-
>> > > >  2 files changed, 9 insertions(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
>> > > > index e00f534..5f62f4e 100644
>> > > > --- a/drivers/mfd/viperboard.c
>> > > > +++ b/drivers/mfd/viperboard.c
>> > > > @@ -64,6 +64,12 @@ static int vprbrd_probe(struct usb_interface *interface,
>> > > >                 return -ENOMEM;
>> > > >         }
>> > > >
>> > > > +       vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
>> > >
>> > > Can you obtain the 'struct device' first then use managed resources
>> > > (devm_*)?
>> >
>> > I think any devres conversion should be done in a follow-up patch and
>> > not be included in the fix (e.g. in order to facilitate backporting). We
>> > also don't want to mix allocation schemes.
>>
>> I agree, but equally I'm not keen on accepting this patch as I believe
>> it could be done better.
>>
>> Please submit two patches, one converting to shared resources and this
>> being the subsequent one, fixed up to do the right thing.
>
> A buffer-corruption fix is a candidate for stable, whereas a devres
> conversion (clean up) is not. Hence the former should not depend on the
> latter.
>

I can follow-up with a v3 3 patch series: first for the fix, second
for the OOM & error path cleanup, third for devm conversion.

I think this will address both issues (backport and better final result).
