Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3HLSes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:34:48 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35908 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HLSeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:34:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5hli47yz01.wl%tiwai@suse.de>
References: <1375430365-13232-2-git-send-email-eu@felipetonello.com>
	<1376029315-3217-1-git-send-email-eu@felipetonello.com>
	<s5h38qj2cqj.wl%tiwai@suse.de>
	<CAGrhNMxj++uJ5HnhhcfOOxhu9u77WMBRP+H5ar5wATi=kHJYKg@mail.gmail.com>
	<s5hli47yz01.wl%tiwai@suse.de>
Date: Mon, 12 Aug 2013 11:34:42 -0700
Message-ID: <CAGrhNMwE+dqoTjr-bCZp__xru77NDri+HayMq+fVZ6n+vzweqA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ALSA: Added jack detection KControl support
From: Felipe Tonello <eu@felipetonello.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Mon, Aug 12, 2013 at 3:39 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 9 Aug 2013 10:36:04 -0700,
> Felipe Tonello wrote:
>>
>> Hi Takashi,
>>
>> On Fri, Aug 9, 2013 at 6:52 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu,  8 Aug 2013 23:21:55 -0700,
>> > Felipe F. Tonello wrote:
>> >>
>> >> From: "Felipe F. Tonello" <eu@felipetonello.com>
>> >>
>> >> This patch adds jack support for ALSA KControl.
>> >>
>> >> This support is necessary since the new kcontrol is used by user-space
>> >> daemons, such as PulseAudio(>=2.0), to do jack detection.)
>> >>
>> >> Also, HDA's CONFIG_SND_HDA_INPUT_JACK is disabled because it causes to use standard
>> >> snd_jack_new() to create jacks. This can cause conflict since this codec creates
>> >> jack controls directly.
>> >>
>> >> It makes sure that all codecs using ALSA jack API are updated to use the new
>> >> API.
>> >
>> > Well, while this is a good move forward, this patch is a bit too
>> > intrusive as a single patch.  It breaks way too many.  "Break then
>> > fix" is no good attitude, especially when it's just something for
>> > future.
>>
>> I agree with you, but unfortunately I had to do that due the
>> non-standard way that jacks are been handled in the kernel and
>> reported to user-space.
>>
>> I believe this is a classic case where we need a well defined kernel
>> API to user-space. I'm not necessarily saying about internal kernel
>> API/ABI, but the one which is exported to user-space. And to be
>> honest, it's kind common to see internal API's been changed.
>>
>> And that's the reason jack detection only work, out of the box, with
>> Intel's HD-audio. Which I think it's pretty bad in the stage we are.
>> More and more embedded running PulseAudio and other core user-space
>> daemons.
>
> I don't mean about the additional support of kctl jack ctl on ASoC.
> It's a damn good thing.
>
> The problem is that you're trying to break the existing stuff, and
> it's done in a single shot without describing details what to do and
> what breaks.  In other words, the proper "process" is missing in your
> approach.

Ok. I will try to follow your instructions.

[...]

>
>> I know that this will potentially break user-space, but the trade off
>> is not to standardize the Jack API. What do you think?
>
> No.  You cannot break.  This is a general golden rule.
>
> The only exception would be if the user-space side will adapt the
> change accordingly together with the kernel change.
>

Got it.

[...]

>>
>> >
>> >
>> >> +             }
>> >>       }
>> >>
>> >>       input_sync(jack->input_dev);
>> >> diff --git a/sound/pci/hda/Kconfig b/sound/pci/hda/Kconfig
>> >> index 59c5e9c..561abc7 100644
>> >> --- a/sound/pci/hda/Kconfig
>> >> +++ b/sound/pci/hda/Kconfig
>> >> @@ -65,14 +65,6 @@ config SND_HDA_INPUT_BEEP_MODE
>> >>         Set 1 to always enable the digital beep interface for HD-audio by
>> >>         default.
>> >>
>> >> -config SND_HDA_INPUT_JACK
>> >> -     bool "Support jack plugging notification via input layer"
>> >> -     depends on INPUT=y || INPUT=SND
>> >> -     select SND_JACK
>> >> -     help
>> >> -       Say Y here to enable the jack plugging notification via
>> >> -       input layer.
>> >> -
>> >
>> > I understand why you remove this Kconfig.  But by this action, you
>> > introduced an obvious regression, i.e. the input jack control is no
>> > longer created for HD-audio.
>>
>> I did this just to see what some HD-audio developers whould say.
>> Because what I would like to see is HD-audio codec also using snd_jack
>> and not export those kct jack functions anymore.
>
> Even if you would like so, you don't rule the world yet, so it can't
> be a reason to disable the whole thing out of sudden :)
>
>> BTW, who uses these input events anyway? Woudn't be better just to
>> have standard way (ALSA KControl) to report it?
>
> Felipe, why wouldn't you drop the whole input jack code for ASoC even
> after you implement kctl jack controls, then?  The same logic can be
> applied to HD-audio input jack controls, too.

Because I tried to maintain this back compatibility. But now I see
that it didn't maintain a lot anyway, because of the jack names.

>
> But, don't get me wrong: I'm not against the action itself, the
> removal of input jack support in HD-audio.  I myself did propose this
> once ago.  Again,  what's missing in your approach is the proper
> process.
>

I see that my patches were kind radical. But at least I'm getting
things clearer now.

> An easier (or lazier) way to manage this problem would be:
>
> - Think whether removal of input-jack support is really needed for
>   HD-audio;
>   for example, if you integrate snd_jack stuff to support both
>   input-jack and kctl jack, HD-audio driver can use it solely instead
>   of calling snd_kctl stuff.  Then both input and kctl jacks will be
>   supported automagically.
>
> - If it's still easier to handle kctl jacks without input jacks in
>   HD-audio, propose the removal at first on the list, get the general
>   consensus.  Then put the removal patch in your series at first.
>
> - Try to keep snd_jack_new() intact but create a new API function for
>   creating both input and kctl jacks.  This would accept two different
>   name strings, one for input jack and one for kctl, with an
>   additional index, if needed.  The different names are needed not to
>   break the things.
>
> - Replace snd_soc_jack_new() with the new function, but you don't have
>   to add the index argument yet at this point.  The handling of
>   multiple input-jack instances with indices isn't defined yet, so the
>   simplest solution would be just to skip the multiple indices.  It
>   should be good enough for ASoC.
>
> - Replace snd_jack_new() in the rest.
>
> - If wanted, obsolete snd_jack_new(), but keep only the new API.

Ok. Nice.

Thanks for all the comments. I appreciate very much.

Felipe Tonello
