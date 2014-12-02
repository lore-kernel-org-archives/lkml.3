Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbaLBXvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:51:53 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:37958 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaLBXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:51:51 -0500
MIME-Version: 1.0
In-Reply-To: <1417561975-27627-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1417561975-27627-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Dec 2014 16:51:30 -0700
Message-ID: <CAErSpo5kFRHjUtNghkL_Db2BaKFOG5vM-rnUOTZAsvFPDd8ebw@mail.gmail.com>
Subject: Re: [PATCH] sound: pci: cmipci.c: Cleaning up function that are not
 used anywhere
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Benoit Taine <benoit.taine@lip6.fr>,
        alsa-devel <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

Thanks a lot for fixing cruft like this.  It makes life better for everybody.

I'll let the maintainer of this driver take care of this patch, but
I'll just point out that your subject ("Cleaning up function ...") is
slightly ambiguous because sometimes "cleanup" means simplification,
not removal.  My personal preference would be "Remove unused
snd_cmipci_pll_rmn()" because it is unambiguous, shorter, and contains
a little more information.  That makes "git log --oneline" output more
 useful.

Bjorn

On Tue, Dec 2, 2014 at 4:12 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove function snd_cmipci_pll_rmn() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  sound/pci/cmipci.c |   41 -----------------------------------------
>  1 file changed, 41 deletions(-)
>
> diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
> index 85ed403..e33edae 100644
> --- a/sound/pci/cmipci.c
> +++ b/sound/pci/cmipci.c
> @@ -615,47 +615,6 @@ static unsigned int snd_cmipci_rate_freq(unsigned int rate)
>
>  #ifdef USE_VAR48KRATE
>  /*
> - * Determine PLL values for frequency setup, maybe the CMI8338 (CMI8738???)
> - * does it this way .. maybe not.  Never get any information from C-Media about
> - * that <werner@suse.de>.
> - */
> -static int snd_cmipci_pll_rmn(unsigned int rate, unsigned int adcmult, int *r, int *m, int *n)
> -{
> -       unsigned int delta, tolerance;
> -       int xm, xn, xr;
> -
> -       for (*r = 0; rate < CM_MAXIMUM_RATE/adcmult; *r += (1<<5))
> -               rate <<= 1;
> -       *n = -1;
> -       if (*r > 0xff)
> -               goto out;
> -       tolerance = rate*CM_TOLERANCE_RATE;
> -
> -       for (xn = (1+2); xn < (0x1f+2); xn++) {
> -               for (xm = (1+2); xm < (0xff+2); xm++) {
> -                       xr = ((CM_REFFREQ_XIN/adcmult) * xm) / xn;
> -
> -                       if (xr < rate)
> -                               delta = rate - xr;
> -                       else
> -                               delta = xr - rate;
> -
> -                       /*
> -                        * If we found one, remember this,
> -                        * and try to find a closer one
> -                        */
> -                       if (delta < tolerance) {
> -                               tolerance = delta;
> -                               *m = xm - 2;
> -                               *n = xn - 2;
> -                       }
> -               }
> -       }
> -out:
> -       return (*n > -1);
> -}
> -
> -/*
>   * Program pll register bits, I assume that the 8 registers 0xf8 up to 0xff
>   * are mapped onto the 8 ADC/DAC sampling frequency which can be chosen
>   * at the register CM_REG_FUNCTRL1 (0x04).
> --
> 1.7.10.4
>
