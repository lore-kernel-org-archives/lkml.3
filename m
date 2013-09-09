Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3IIPxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:53:23 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37515 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3IIPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <E1VImxG-0002w1-UA@tartarus.angband.pl>
References: <E1VImxG-0002w1-UA@tartarus.angband.pl>
Date: Mon, 9 Sep 2013 17:53:19 +0200
Message-ID: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
Subject: Re: [PATCH] vt: properly ignore xterm-256 colour codes
From: David Herrmann <dh.herrmann@gmail.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jul 12, 2013 at 10:23 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> This is not a bug on our side, but a misdesign in ITU T.416, yet with
> all popular terminals supporting these codes, people consider this to
> be a bug in Linux.  By breaking the design principles behind SGR codes
> (gracefully ignoring unsupported ones should not require knowing about
> them), 256 colour ones tend to turn blinking on before invoking an
> arbitrary unrelated command.
>
> This commit doesn't add such support, merely skips such codes without
> ill effects.
>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  drivers/tty/vt/vt.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index c677829..f7aaa28 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -1300,13 +1300,27 @@ static void csi_m(struct vc_data *vc)
>                         case 27:
>                                 vc->vc_reverse = 0;
>                                 break;
> -                       case 38: /* ANSI X3.64-1979 (SCO-ish?)
> -                                 * Enables underscore, white foreground
> -                                 * with white underscore (Linux - use
> -                                 * default foreground).
> +                       case 38:
> +                       case 48: /* ITU T.416
> +                                 * Higher colour modes.
> +                                 * They break the usual properties of SGR codes
> +                                 * and thus need to be detected and ignored by
> +                                 * hand.  Strictly speaking, that standard also
> +                                 * wants : rather than ; as separators, contrary
> +                                 * to ECMA-48, but no one produces such codes
> +                                 * and almost no one accepts them.
>                                   */
> -                               vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
> -                               vc->vc_underline = 1;

You break the old behavior here. _Iff_ this is what you want, then
please do that in another commit. Explicitly state that "38" is used
for 256color and shouldn't turn on underline+default-col. The SCO-ish
behavior is weird, indeed, but breaking it silently is not ok.

> +                               i++;
> +                               if (i > vc->vc_npar)

This should be ">=", but the for()-loop does allow your ">". So unless
someone fixes the for-loop to use "<" (do a ++vc->vc_npar before it,
if it's correct. But blindly doing "<=" is really irritating) I think
this is ok.

> +                                       break;
> +                               if (vc->vc_par[i] == 5)      /* 256 colours */
> +                                       i++;                 /* ubiquitous */
> +                               else if (vc->vc_par[i] == 2) /* 24 bit colours */
> +                                       i += 3;              /* extremely rare */
> +                               /* Subcommands 3 (CMY) and 4 (CMYK) are so insane
> +                                * that detecting them is not worth the few extra
> +                                * bytes of kernel's size.
> +                                */

I can confirm that 38/48 are "parsed" correctly here. Skipping '3' and
'4' seems right, too. Haven't seen anyone implementing them. Even '2'
seems to be almost unused.

Btw., you should put Greg Kroah-Hartman and Andrew Morton on CC. Both
are the most likely to pick this up.

Regards
David

>                                 break;
>                         case 39: /* ANSI X3.64-1979 (SCO-ish?)
>                                   * Disable underline option.
> --
> 1.8.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
