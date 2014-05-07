Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaEGVQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:16:06 -0400
Received: from mail001.aei.ca ([206.123.6.130]:34939 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaEGVQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:16:03 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bryan Quigley <gquigs@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Pulseaudio hung at schedule in 3.15-rc1
Date: Wed, 07 May 2014 17:15:54 -0400
Message-ID: <4388285.aVlCXYDkI5@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.15.0-1-git; KDE/4.13.0; x86_64; ; )
In-Reply-To: <s5h61loskcf.wl%tiwai@suse.de>
References: <CAAWf5=s-hQ2xMtLxNFXjXH6UGmQtgkrzS9zWj3z_CTq41XGpdw@mail.gmail.com> <CAAWf5=s=jrUa2wi6z5djW4rWA-PUS0q5pN3jU+ph0s8vxu65GQ@mail.gmail.com> <s5h61loskcf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi,

I also hit this one with a webcam.  Your patch below fixes it here too.
You can add:

Tested-by: Ed Tomlinson	<edtoml@gmail.com>

If you want

Thanks
Ed 


On Friday 02 May 2014 09:36:32 Takashi Iwai wrote:
> At Wed, 30 Apr 2014 13:40:11 -0400,
> Bryan Quigley wrote:
> > 
> > > Hm, what about the one below instead?
> > >
> > >
> > > Takashi
> > 
> > It works now!  Still gives me some errors, but both the webcam and
> > microphone function fine..
> > 
> > On pluging it in, all seems normal:
> > Apr 30 13:33:29 dell-laptop kernel: [  467.144143] usb 2-2: new
> > high-speed USB device number 4 using ehci-pci
> > Apr 30 13:33:30 dell-laptop kernel: [  467.492931] usb 2-2: New USB
> > device found, idVendor=046d, idProduct=0825
> > Apr 30 13:33:30 dell-laptop kernel: [  467.492939] usb 2-2: New USB
> > device strings: Mfr=0, Product=0, SerialNumber=2
> > Apr 30 13:33:30 dell-laptop kernel: [  467.492943] usb 2-2:
> > SerialNumber: 0911F220
> > Apr 30 13:33:30 dell-laptop kernel: [  467.493799] uvcvideo: Found UVC
> > 1.00 device <unnamed> (046d:0825)
> > Apr 30 13:33:30 dell-laptop kernel: [  467.590713] input: UVC Camera
> > (046d:0825) as /devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2:1.0/input/input20
> > Apr 30 13:33:31 dell-laptop kernel: [  468.753801] usb 2-2: set
> > resolution quirk: cval->res = 384
> > 
> > But on any access (sudo lsusb -v, open webcam, etc), it will give:
> > Apr 30 13:35:21 dell-laptop kernel: [  578.788135] usb 2-2: reset
> > high-speed USB device number 4 using ehci-pci
> > Apr 30 13:35:21 dell-laptop kernel: [  579.142380] snd-usb-audio
> > 2-2:1.2: reset_resume error -5
> > 
> > Doesn't seem to affect performance at all though..
> 
> OK, the error above comes from my patch returning an error at auto
> suspend callback.  How about the revised patch below?
> 
> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index 893d5a1afc3c..c3b5b7dca1c3 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -651,7 +651,7 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
>  	int err = -ENODEV;
>  
>  	down_read(&chip->shutdown_rwsem);
> -	if (chip->probing)
> +	if (chip->probing && chip->in_pm)
>  		err = 0;
>  	else if (!chip->shutdown)
>  		err = usb_autopm_get_interface(chip->pm_intf);
> @@ -663,7 +663,7 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
>  void snd_usb_autosuspend(struct snd_usb_audio *chip)
>  {
>  	down_read(&chip->shutdown_rwsem);
> -	if (!chip->shutdown && !chip->probing)
> +	if (!chip->shutdown && !chip->probing && !chip->in_pm)
>  		usb_autopm_put_interface(chip->pm_intf);
>  	up_read(&chip->shutdown_rwsem);
>  }
> @@ -695,8 +695,9 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
>  			chip->autosuspended = 1;
>  	}
>  
> -	list_for_each_entry(mixer, &chip->mixer_list, list)
> -		snd_usb_mixer_suspend(mixer);
> +	if (chip->num_suspended_intf == 1)
> +		list_for_each_entry(mixer, &chip->mixer_list, list)
> +			snd_usb_mixer_suspend(mixer);
>  
>  	return 0;
>  }
> @@ -711,6 +712,8 @@ static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
>  		return 0;
>  	if (--chip->num_suspended_intf)
>  		return 0;
> +
> +	chip->in_pm = 1;
>  	/*
>  	 * ALSA leaves material resumption to user space
>  	 * we just notify and restart the mixers
> @@ -726,6 +729,7 @@ static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
>  	chip->autosuspended = 0;
>  
>  err_out:
> +	chip->in_pm = 0;
>  	return err;
>  }
>  
> diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
> index 25c4c7e217de..91d0380431b4 100644
> --- a/sound/usb/usbaudio.h
> +++ b/sound/usb/usbaudio.h
> @@ -40,6 +40,7 @@ struct snd_usb_audio {
>  	struct rw_semaphore shutdown_rwsem;
>  	unsigned int shutdown:1;
>  	unsigned int probing:1;
> +	unsigned int in_pm:1;
>  	unsigned int autosuspended:1;	
>  	unsigned int txfr_quirk:1; /* Subframe boundaries on transfers */
>  	
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

