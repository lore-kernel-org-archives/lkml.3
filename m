Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbaD3QLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:11:19 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59820 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042AbaD3QLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:11:12 -0400
MIME-Version: 1.0
In-Reply-To: <s5hioprs4hb.wl%tiwai@suse.de>
References: <CAAWf5=s-hQ2xMtLxNFXjXH6UGmQtgkrzS9zWj3z_CTq41XGpdw@mail.gmail.com>
 <s5h4n1ov8h9.wl%tiwai@suse.de> <CAAWf5=usG_Q-11kMd=58mVEELb8b0nyBXanaDqKqCGSFVJP0Rw@mail.gmail.com>
 <s5hbnvk9pxn.wl%tiwai@suse.de> <CAAWf5=tENLeh8VeM2i_FwYiqGYtZEMZ625XQTjx6nutE=A46Mg@mail.gmail.com>
 <s5hioprs4hb.wl%tiwai@suse.de>
From: Bryan Quigley <gquigs@gmail.com>
Date: Wed, 30 Apr 2014 12:10:48 -0400
Message-ID: <CAAWf5=tzBW5pBNBnO1URoo1Z1O-rTnVOpeAyMs73tqYNyjF-_Q@mail.gmail.com>
Subject: Re: PROBLEM: Pulseaudio hung at schedule in 3.15-rc1
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still issues, on plugging it in after boot and running sudo lsusb -v
Apr 30 11:53:30 dell-laptop kernel: [   54.320063] usb 6-2: new
full-speed USB device number 2 using uhci_hcd
Apr 30 11:53:30 dell-laptop kernel: [   54.680097] usb 6-2: not
running at top speed; connect to a high speed hub
Apr 30 11:53:30 dell-laptop kernel: [   54.822100] usb 6-2: New USB
device found, idVendor=046d, idProduct=0825
Apr 30 11:53:30 dell-laptop kernel: [   54.822106] usb 6-2: New USB
device strings: Mfr=0, Product=0, SerialNumber=2
Apr 30 11:53:30 dell-laptop kernel: [   54.822109] usb 6-2:
SerialNumber: 0911F220
Apr 30 11:53:30 dell-laptop kernel: [   54.825210] uvcvideo: Found UVC
1.00 device <unnamed> (046d:0825)
Apr 30 11:53:30 dell-laptop kernel: [   54.925311] input: UVC Camera
(046d:0825) as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input18
Apr 30 11:53:31 dell-laptop kernel: [   56.107099] usb 6-2: set
resolution quirk: cval->res = 384
Apr 30 11:53:31 dell-laptop kernel: [   56.107353] usbcore: registered
new interface driver snd-usb-audio
Apr 30 11:53:36 dell-laptop kernel: [   60.869958] usb 6-2: 3:1:
usb_set_interface failed (-113)
Apr 30 11:53:36 dell-laptop kernel: [   60.869991] usb 6-2: 3:1:
usb_set_interface failed (-113)
(Repeats until device is reset)

The above also happens on bootup.  (No longer hangs pulseaudio because
the device seems to fail..).

Thanks,
Bryan


On Wed, Apr 30, 2014 at 2:42 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 29 Apr 2014 14:04:15 -0400,
> Bryan Quigley wrote:
>>
>> I pastebined the full boots syslog here: http://pastebin.ubuntu.com/7360925/
>>
>> The only kernel error I get is that pulseaudio hangs.. Nothing more
>> specific as to why.
>> I can also get a hang if I just run: sudo lsusb -v.  It displays
>> Bus 002 Device 002: ID 046d:0825 Logitech, Inc. Webcam C270
>> [blinking cursor]
>
> Thanks.  Could you try the patch below?
>
>
> Takashi
>
> ---
> diff --git a/sound/usb/card.c b/sound/usb/card.c
> index 893d5a1afc3c..28f13def4838 100644
> --- a/sound/usb/card.c
> +++ b/sound/usb/card.c
> @@ -651,7 +651,7 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
>         int err = -ENODEV;
>
>         down_read(&chip->shutdown_rwsem);
> -       if (chip->probing)
> +       if (chip->probing || chip->num_suspended_intf)
>                 err = 0;
>         else if (!chip->shutdown)
>                 err = usb_autopm_get_interface(chip->pm_intf);
> @@ -663,7 +663,7 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
>  void snd_usb_autosuspend(struct snd_usb_audio *chip)
>  {
>         down_read(&chip->shutdown_rwsem);
> -       if (!chip->shutdown && !chip->probing)
> +       if (!chip->shutdown && !chip->probing && !chip->num_suspended_intf)
>                 usb_autopm_put_interface(chip->pm_intf);
>         up_read(&chip->shutdown_rwsem);
>  }
> @@ -695,8 +695,10 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
>                         chip->autosuspended = 1;
>         }
>
> -       list_for_each_entry(mixer, &chip->mixer_list, list)
> -               snd_usb_mixer_suspend(mixer);
> +       if (chip->num_suspended_intf == 1) {
> +               list_for_each_entry(mixer, &chip->mixer_list, list)
> +                       snd_usb_mixer_suspend(mixer);
> +       }
>
>         return 0;
>  }
