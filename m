Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbbAEPuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbbAEPug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:50:36 -0500
Date: Mon, 5 Jan 2015 10:50:31 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Gottschlag <mgottschlag@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: psmouse - use IS_ENABLED instead of homegrown code
Message-ID: <20150105155031.GG19391@mail.corp.redhat.com>
References: <20141229201139.GA1690@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141229201139.GA1690@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29 2014 or thereabouts, Dmitry Torokhov wrote:
> Instead of having various protocols provide <protocol>_supported()
> functions, let's use IS_ENABLED() macro that works well in "if" statements.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

>  drivers/input/mouse/cypress_ps2.c  |  5 -----
>  drivers/input/mouse/cypress_ps2.h  |  5 -----
>  drivers/input/mouse/focaltech.c    | 10 ----------
>  drivers/input/mouse/focaltech.h    |  1 -
>  drivers/input/mouse/psmouse-base.c |  6 +++---
>  drivers/input/mouse/synaptics.c    | 10 ----------
>  drivers/input/mouse/synaptics.h    |  1 -
>  7 files changed, 3 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/input/mouse/cypress_ps2.c b/drivers/input/mouse/cypress_ps2.c
> index 8af34ff..6e5f70b 100644
> --- a/drivers/input/mouse/cypress_ps2.c
> +++ b/drivers/input/mouse/cypress_ps2.c
> @@ -710,8 +710,3 @@ err_exit:
>  
>  	return -1;
>  }
> -
> -bool cypress_supported(void)
> -{
> -	return true;
> -}
> diff --git a/drivers/input/mouse/cypress_ps2.h b/drivers/input/mouse/cypress_ps2.h
> index 4720f21..81f68aa 100644
> --- a/drivers/input/mouse/cypress_ps2.h
> +++ b/drivers/input/mouse/cypress_ps2.h
> @@ -172,7 +172,6 @@ struct cytp_data {
>  #ifdef CONFIG_MOUSE_PS2_CYPRESS
>  int cypress_detect(struct psmouse *psmouse, bool set_properties);
>  int cypress_init(struct psmouse *psmouse);
> -bool cypress_supported(void);
>  #else
>  inline int cypress_detect(struct psmouse *psmouse, bool set_properties)
>  {
> @@ -182,10 +181,6 @@ inline int cypress_init(struct psmouse *psmouse)
>  {
>  	return -ENOSYS;
>  }
> -inline bool cypress_supported(void)
> -{
> -	return 0;
> -}
>  #endif /* CONFIG_MOUSE_PS2_CYPRESS */
>  
>  #endif  /* _CYPRESS_PS2_H */
> diff --git a/drivers/input/mouse/focaltech.c b/drivers/input/mouse/focaltech.c
> index fca38ba..757f78a 100644
> --- a/drivers/input/mouse/focaltech.c
> +++ b/drivers/input/mouse/focaltech.c
> @@ -424,11 +424,6 @@ fail:
>  	return error;
>  }
>  
> -bool focaltech_supported(void)
> -{
> -	return true;
> -}
> -
>  #else /* CONFIG_MOUSE_PS2_FOCALTECH */
>  
>  int focaltech_init(struct psmouse *psmouse)
> @@ -438,9 +433,4 @@ int focaltech_init(struct psmouse *psmouse)
>  	return 0;
>  }
>  
> -bool focaltech_supported(void)
> -{
> -	return false;
> -}
> -
>  #endif /* CONFIG_MOUSE_PS2_FOCALTECH */
> diff --git a/drivers/input/mouse/focaltech.h b/drivers/input/mouse/focaltech.h
> index 71870a9..ca61ebf 100644
> --- a/drivers/input/mouse/focaltech.h
> +++ b/drivers/input/mouse/focaltech.h
> @@ -19,6 +19,5 @@
>  
>  int focaltech_detect(struct psmouse *psmouse, bool set_properties);
>  int focaltech_init(struct psmouse *psmouse);
> -bool focaltech_supported(void);
>  
>  #endif
> diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
> index 68469fe..4ccd01d 100644
> --- a/drivers/input/mouse/psmouse-base.c
> +++ b/drivers/input/mouse/psmouse-base.c
> @@ -727,7 +727,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
>  	if (psmouse_do_detect(focaltech_detect, psmouse, set_properties) == 0) {
>  		if (max_proto > PSMOUSE_IMEX) {
>  			if (!set_properties || focaltech_init(psmouse) == 0) {
> -				if (focaltech_supported())
> +				if (IS_ENABLED(CONFIG_MOUSE_PS2_FOCALTECH))
>  					return PSMOUSE_FOCALTECH;
>  				/*
>  				 * Note that we need to also restrict
> @@ -776,7 +776,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
>   * Try activating protocol, but check if support is enabled first, since
>   * we try detecting Synaptics even when protocol is disabled.
>   */
> -			if (synaptics_supported() &&
> +			if (IS_ENABLED(CONFIG_MOUSE_PS2_SYNAPTICS) &&
>  			    (!set_properties || synaptics_init(psmouse) == 0)) {
>  				return PSMOUSE_SYNAPTICS;
>  			}
> @@ -801,7 +801,7 @@ static int psmouse_extensions(struct psmouse *psmouse,
>   */
>  	if (max_proto > PSMOUSE_IMEX &&
>  			cypress_detect(psmouse, set_properties) == 0) {
> -		if (cypress_supported()) {
> +		if (IS_ENABLED(CONFIG_MOUSE_PS2_CYPRESS)) {
>  			if (cypress_init(psmouse) == 0)
>  				return PSMOUSE_CYPRESS;
>  
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index f947292..094bf64 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -1817,11 +1817,6 @@ int synaptics_init_relative(struct psmouse *psmouse)
>  	return __synaptics_init(psmouse, false);
>  }
>  
> -bool synaptics_supported(void)
> -{
> -	return true;
> -}
> -
>  #else /* CONFIG_MOUSE_PS2_SYNAPTICS */
>  
>  void __init synaptics_module_init(void)
> @@ -1833,9 +1828,4 @@ int synaptics_init(struct psmouse *psmouse)
>  	return -ENOSYS;
>  }
>  
> -bool synaptics_supported(void)
> -{
> -	return false;
> -}
> -
>  #endif /* CONFIG_MOUSE_PS2_SYNAPTICS */
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index 1bd01f2..feb28a5 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -191,6 +191,5 @@ int synaptics_detect(struct psmouse *psmouse, bool set_properties);
>  int synaptics_init(struct psmouse *psmouse);
>  int synaptics_init_relative(struct psmouse *psmouse);
>  void synaptics_reset(struct psmouse *psmouse);
> -bool synaptics_supported(void);
>  
>  #endif /* _SYNAPTICS_H */
> -- 
> 2.2.0.rc0.207.ga3a616c
> 
> 
> -- 
> Dmitry
