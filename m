Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaKNJQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:16:26 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35230 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaKNJQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:16:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141104003827.GA24005@ti.com>
References: <1413922198-29373-1-git-send-email-bparrot@ti.com>
	<CACRpkdak3EACNpgEznN85d7gPHsMOBW+Ondwx23XhLaVEdjo8Q@mail.gmail.com>
	<20141104003827.GA24005@ti.com>
Date: Fri, 14 Nov 2014 10:16:20 +0100
Message-ID: <CACRpkdYY3CEdKak_x=YMZ22XzhXcnzYLTsaAUx3DfGBi3-Kt6A@mail.gmail.com>
Subject: Re: [RFC Patch] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Parrot <bparrot@ti.com>, Alexandre Courbot <gnurou@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 1:38 AM, Benoit Parrot <bparrot@ti.com> wrote:

Sorry for slow replies...

> Linus Walleij <linus.walleij@linaro.org> wrote on Mon [2014-Nov-03 10:59:53 +0100]:
>> On Tue, Oct 21, 2014 at 10:09 PM, Benoit Parrot <bparrot@ti.com> wrote:
>>
>> >         qe_pio_a: gpio-controller@1400 {
>> > @@ -110,6 +130,19 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
>> >                 reg = <0x1400 0x18>;
>> >                 gpio-controller;
>> >                 #gpio-cells = <2>;
>> > +               gpio-hogs = <&line_b>;
>> > +
>> > +               /* line_a hog is defined but not enabled in this example*/
>> > +               line_a: line_a {
>> > +                       gpios = <5 0>;
>> > +                       input;
>> > +               };
>> > +
>> > +               line_b: line_b {
>> > +                       gpios = <6 0>;
>> > +                       output-low;
>> > +                       line-name = "foo-bar-gpio";
>> > +               };
>>
>>
>> I don't see the point of having unused hogs and enabling them using
>> phandles.
>>
>> Just let the core walk over all children nodes of a GPIO controller
>> and hog them. Put in a bool property saying it's a hog.
>>
>> +               line_b: line_b {
>> +                       gpio-hog;
>> +                       gpios = <6 0>;
>> +                       output-low;
>> +                       line-name = "foo-bar-gpio";
>> +               };
>>
>> I don't quite see the point with input hogs that noone can use
>> but whatever.
>>
>> I am thinking that maybe the line name should be compulsory
>> so as to improbe readability. I mean there is always a reason
>> why you're hogging a pin and the name should say it.
>
> Ok, so as an alternative I had presented something like this in my reply
> to Alexandre Courbot's review comments:
>
>   I did consider a "pinmux" flavored format (not sure how hard to parse it would be).
>   It would allow grouping if nothing else.
>
>         /* Line syntax: line_name <gpio# flags> direction-value [export] */
>         gpio-hogs = <&group_y>;
>
>         group_y: group_y {
>                 gpio-hogs-group = <
>                         line_x <15 0> output-low
>                         line_y <16 0> output-high export
>                         line_z <17 0> input
>                 >;
>         };
>
> Now based on your comment would something like this work?
>
>      qe_pio_a: gpio-controller@1400 {
>         reg = <0x1400 0x18>;
>         gpio-controller;
>         #gpio-cells = <2>;
>
>         /* Line syntax: line_name <gpio# flags> direction-value [export] */
>         gpio-hogs: {
>                 gpio-hogs-group = <
>                         foo-bar-gpio <15 0> output-low
>                         bar-foo-gpio <16 0> output-high export
>                 >;
>         };
>      };

I *DON'T* want to mix up the exporting interface with the hogging
mechanism. These have to be two different things and different
patches.

But it looks strange and a bit convoluted. I don't see the point
of the grouping concept. There are ages old mails where I suggest
a very flat mechanism like this:

qe_pio_a: gpio-controller@1400 {
   reg = <0x1400 0x18>;
   gpio-controller;
   #gpio-cells = <2>;
   gpio-hogs-output-high = <15 0>, <12 0>;
   gpio-hogs-output-low = <16 0>;
};

I understand that if you want to give names to the pins that
is maybe a bit terse, then I suggest these named nodes:

qe_pio_a: gpio-controller@1400 {
   reg = <0x1400 0x18>;
   gpio-controller;
   #gpio-cells = <2>;
   {
       gpio-hog-output-high = <15 0>;
       line-name = "foo";
   };
   {
       gpio-hog-output-high = <12 0>;
       line-name = "bar";
   };
   {
       gpio-hog-output-low = <16 0>;
       line-name = "baz";
   };
};

This is pretty straight-forward to parse from the device
tree by just walking over the children of a GPIO controller
node and looking for the hog keywords and optional
line names.

This mechanism can later add some per-pin export
keyword too, if that is desired. But that is a separate
discussion.

Still no need for groups or phandles or stuff like that...

It's a terser version of what I suggested in the last
reply from me:

+               line_b: line_b {
+                       gpio-hog;
+                       gpios = <6 0>;
+                       output-low;
+                       line-name = "foo-bar-gpio";
+               };

Just that I combine gpio-hog, gpios and output-low
into one property.

Any version works, I just don't get this grouping and
phandle business, if such complexity is needed it has
to be motivated.

> This would group all hogs for one controller under a single child node.

Why is that a desireable feature?

I will try to find the other mail thread...

Yours,
Linus Walleij
