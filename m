Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3GXOL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:11:57 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33781 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479Ab3GXOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:11:55 -0400
Message-ID: <51EFE0A3.80709@hurleysoftware.com>
Date: Wed, 24 Jul 2013 10:11:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gianluca Anzolin <gianluca@sottospazio.it>, gregkh@linuxfoundation.org
CC: Gustavo Padovan <gustavo@padovan.org>, linux-kernel@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: [PATCH] Fix refcount leak in tty_port.c
References: <20130709083535.GA30227@debian.seek.priv> <20130712103026.GC2065@joana> <51E00CF1.6070302@hurleysoftware.com>
In-Reply-To: <51E00CF1.6070302@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 10:04 AM, Peter Hurley wrote:
> On 07/12/2013 06:30 AM, Gustavo Padovan wrote:
>> Hi Gianluca,
>>
>> * Gianluca Anzolin <gianluca@sottospazio.it> [2013-07-09 10:35:35 +0200]:
>>
>>> Hello,
>>>
>>> In linux 3.10 in the file drivers/tty/tty_port.c the function
>>> tty_port_tty_hangup may leak a tty reference:
>>>
>>>          struct tty_struct *tty = tty_port_tty_get(port);
>>>
>>>          if (tty && (!check_clocal || !C_CLOCAL(tty))) {
>>>                  tty_hangup(tty);
>>>                  tty_kref_put(tty);
>>>          }
>>>
>>> If tty != NULL and the second condition is false we never call tty_kref_put and
>>> the reference is leaked.
>
> Good catch.
>
>>> Fix by nesting two if statements.
>>>
>>> Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
>>
>> As mentioned by Gianluca this is a regression of aa27a094 and we depend on
>> this patch to go ahead with some fixes in the bluetooth subsystem.
>
> Gustavo,
>
> There's no direct dependency; ie., there aren't merge issues here.
> We should progress with the fixes to rfcomm independent of this patch.
>
>> Gianluca, it might help if you send a proper git inline formated patch,
>> mentioning the issue and which regression you are fixing.  It makes
>> maintainer's life easier.
>
> As Gustavo points out, please inline the patch otherwise commenters
> have to do it for you.

Gianluca,

I think Greg may be expecting you to address the comments from myself
and Gustavo before accepting this patch.

Greg, is that the case?

Regards,
Peter Hurley

>> Also add my Ack to the patch:
>  >
>>
>> Acked-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
>>
>>     Gustavo
>
> Copy of the Gianluca's patch with my comments
>
> --- %< ---
>
> Please put a proper commit message here, including that this is
> a regression and the commit id that caused the regression so this patch
> can eventually make its way to stable.
>
>
>  > diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
>  > index 121aeb9..2198f7d 100644
>  > --- a/drivers/tty/tty_port.c
>  > +++ b/drivers/tty/tty_port.c
>  > @@ -256,8 +256,9 @@ void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
>  >  {
>  >      struct tty_struct *tty = tty_port_tty_get(port);
>  >
>  > -    if (tty && (!check_clocal || !C_CLOCAL(tty))) {
>  > -        tty_hangup(tty);
>  > +    if (tty) {
>  > +        if (!check_clocal || !C_CLOCAL(tty))
>  > +            tty_hangup(tty);
>  >          tty_kref_put(tty);
>  >      }
>  >  }
>
>
> tty_kref_put() already checks for NULL tty. I would prefer:
>
> {
>        struct tty_struct *tty = tty_port_tty_get(port);
>
>      if (tty && (!check_clocal || !C_CLOCAL(tty)))
>          tty_hangup(tty);
>      tty_kref_put(tty);
> }


