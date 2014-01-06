Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaAFS5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:57:17 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54194 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbaAFS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:57:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAA25o9ScgzY1TbqKoe2KbSCc-DUBFLstDyYWY=LmdL+ioX82Ug@mail.gmail.com>
References: <20131231193530.GA25261@core.coreip.homeip.net>
	<CAD=FV=VZyXs9b+UyzuWNHBwKWEVcEvSZ4xdtsJLD+TFnRJon6A@mail.gmail.com>
	<20140102194817.GC2025@core.coreip.homeip.net>
	<CAA25o9ScgzY1TbqKoe2KbSCc-DUBFLstDyYWY=LmdL+ioX82Ug@mail.gmail.com>
Date: Mon, 6 Jan 2014 10:57:14 -0800
X-Google-Sender-Auth: rFI0c7-HalNqfdW_lM9h40SjEIo
Message-ID: <CAD=FV=UCEcTr+X-=yNxo1VnJ1B8kJ=wDbR7H_S3AYvBGLU7tEw@mail.gmail.com>
Subject: Re: [PATCH] Input: cros_ec_keyb - avoid variable-length arrays on stack
From: Doug Anderson <dianders@chromium.org>
To: Luigi Semenzato <semenzato@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Simon Glass <sjg@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 4:25 PM, Luigi Semenzato <semenzato@chromium.org> wrote:
> On Thu, Jan 2, 2014 at 11:48 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> Hi Doug,
>>
>> On Thu, Jan 02, 2014 at 09:40:44AM -0800, Doug Anderson wrote:
>>> Dmitry,
>>>
>>> Thanks for cleaning up cros_eckeyb.  :)  I'm a little curious about
>>> the motivation here.  I can't imagine a keyboard with all that many
>>> columns (ours has 13), so it's really not taking a whole lot off of
>>> the stack.  Are you trying to make some sort of automated checker
>>> happy, or just generally trying to keep the kernel consistent?
>>
>> I compile most of the code with sparse so I prefer to keep it happy.
>>
>>>
>>> In any case, I'm not opposed to moving these bytes off the stack.
>>> Comments below, though...
>>>
>>> ---
>>>
>>> On Tue, Dec 31, 2013 at 11:35 AM, Dmitry Torokhov
>>> <dmitry.torokhov@gmail.com> wrote:
...
>>> > @@ -217,32 +219,40 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
>>> >         struct cros_ec_keyb *ckdev;
>>> >         struct input_dev *idev;
>>> >         struct device_node *np;
>>> > +       unsigned int rows, cols;
>>> > +       size_t size;
>>> >         int err;
>>> >
>>> >         np = pdev->dev.of_node;
>>> >         if (!np)
>>> >                 return -ENODEV;
>>> >
>>> > -       ckdev = devm_kzalloc(&pdev->dev, sizeof(*ckdev), GFP_KERNEL);
>>> > -       if (!ckdev)
>>> > -               return -ENOMEM;
>>> > -       err = matrix_keypad_parse_of_params(&pdev->dev, &ckdev->rows,
>>> > -                                           &ckdev->cols);
>>> > +       err = matrix_keypad_parse_of_params(&pdev->dev, &rows, &cols);
>>> >         if (err)
>>> >                 return err;
>>> > -       ckdev->old_kb_state = devm_kzalloc(&pdev->dev, ckdev->cols, GFP_KERNEL);
>>> > -       if (!ckdev->old_kb_state)
>>> > -               return -ENOMEM;
>>> >
>>> > -       idev = devm_input_allocate_device(&pdev->dev);
>>> > -       if (!idev)
>>> > +       /*
>>> > +        * Double memory for keyboard state so we have space for storing
>>> > +        * current and previous state.
>>> > +        */
>>> > +       size = sizeof(*ckdev) + 2 * cols * sizeof(*ckdev->kb_state);
>>> > +       ckdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
>>> > +       if (!ckdev)
>>> >                 return -ENOMEM;
>>>
>>> This change seems like a lot of complexity to save one memory
>>> allocation.  If you insist, I'd be OK with having one allocation for
>>> both buffers (kb_state and old_kb_state) but trying to jam this onto
>>> the end of the structure is non-obvious.  It certainly took me a
>>> minute to understand what you were doing and why.
>>
>> It is not one additional allocation but more as you need to allocate
>> devres data structures and add them there. I think we have quite a few
>> drivers piggy-backing key tables at the end of data structures.

OK, I will leave this as your call.  To me, piggybacking like this
make sense if you've got a single chunk of dynamic memory that you
just want to cram onto the end of the structure.  It just gets more
complicated when you have two nearly identical chunks of memory and
one of them is using this piggybacking technique while the other
isn't.

What about a compromise and declaring as:

 u8 *kb_state;
 u8 *old_kb_state;
 u8 buffers[];

You still have the same number of memory allocations but (to me) it's
much clearer what's going on here.  You do pay a penalty of an extra
memory dereference and an extra 4 bytes of memory, but clarity should
trump that.

-Doug
