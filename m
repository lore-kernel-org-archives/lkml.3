Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaDXEcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:32:42 -0400
Received: from ozlabs.org ([103.22.144.67]:58581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaDXEcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:32:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Christopher Brannon <chris@the-brannons.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 6/9] drivers/staging/speakup/: avoid world-writable sysfs files.
In-Reply-To: <20140422163736.GA23831@kroah.com>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au> <1398137612-9714-7-git-send-email-rusty@rustcorp.com.au> <20140422163736.GA23831@kroah.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Apr 2014 13:57:49 +0930
Message-ID: <87bnvrfj22.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> On Tue, Apr 22, 2014 at 01:03:29PM +0930, Rusty Russell wrote:
>> In line with practice for module parameters, we're adding a build-time
>> check that sysfs files aren't world-writable.
>
> Then why not just use the __ATTR_RO() macro?

Hmm, I didn't know those variants existed :(

But most of these are not amenable to __ATTR_RO etc, since they call
generic helpers, eg:

	__ATTR(delimiters, S_IWUGO|S_IRUGO, punc_show, punc_store);

I dislike the __ATTR_RO etc macros: hiding the references to the
function from grep is Too Much Magic.  (Sure, I do it in module_param,
but that has the excuse that it allows typechecking as well).

> I'd prefer some "standard" permissions for all of these sysfs files,
> it's quite confusing otherwise, don't you agree?

Agreed.  So I used S_IWUSR | S_IRUGO everywhere, which is what ATTR_RW
uses.

Cheers,
Rusty.

Subject: drivers/staging/speakup/: avoid world-writable sysfs files.

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Christopher Brannon <chris@the-brannons.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index 1ca91f7092b1..bca5f4f8a8bb 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -851,75 +851,75 @@ static ssize_t message_store(struct kobject *kobj, struct kobj_attribute *attr,
  * Declare the attributes.
  */
 static struct kobj_attribute keymap_attribute =
-	__ATTR(keymap, S_IWUSR|S_IRUGO, keymap_show, keymap_store);
+	__ATTR_RW(keymap);
 static struct kobj_attribute silent_attribute =
-	__ATTR(silent, S_IWUGO, NULL, silent_store);
+	__ATTR_WO(silent);
 static struct kobj_attribute synth_attribute =
-	__ATTR(synth, S_IWUGO|S_IRUGO, synth_show, synth_store);
+	__ATTR_RW(synth);
 static struct kobj_attribute synth_direct_attribute =
-	__ATTR(synth_direct, S_IWUGO, NULL, synth_direct_store);
+	__ATTR_WO(synth_direct);
 static struct kobj_attribute version_attribute =
 	__ATTR_RO(version);
 
 static struct kobj_attribute delimiters_attribute =
-	__ATTR(delimiters, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(delimiters, S_IWUSR|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute ex_num_attribute =
-	__ATTR(ex_num, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(ex_num, S_IWUSR|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_all_attribute =
-	__ATTR(punc_all, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(punc_all, S_IWUSR|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_most_attribute =
-	__ATTR(punc_most, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(punc_most, S_IWUSR|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute punc_some_attribute =
-	__ATTR(punc_some, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(punc_some, S_IWUSR|S_IRUGO, punc_show, punc_store);
 static struct kobj_attribute repeats_attribute =
-	__ATTR(repeats, S_IWUGO|S_IRUGO, punc_show, punc_store);
+	__ATTR(repeats, S_IWUSR|S_IRUGO, punc_show, punc_store);
 
 static struct kobj_attribute attrib_bleep_attribute =
-	__ATTR(attrib_bleep, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(attrib_bleep, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bell_pos_attribute =
-	__ATTR(bell_pos, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(bell_pos, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bleep_time_attribute =
-	__ATTR(bleep_time, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(bleep_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute bleeps_attribute =
-	__ATTR(bleeps, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(bleeps, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute cursor_time_attribute =
-	__ATTR(cursor_time, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(cursor_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute key_echo_attribute =
-	__ATTR(key_echo, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(key_echo, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute no_interrupt_attribute =
-	__ATTR(no_interrupt, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(no_interrupt, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punc_level_attribute =
-	__ATTR(punc_level, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punc_level, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute reading_punc_attribute =
-	__ATTR(reading_punc, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(reading_punc, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute say_control_attribute =
-	__ATTR(say_control, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(say_control, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute say_word_ctl_attribute =
-	__ATTR(say_word_ctl, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(say_word_ctl, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute spell_delay_attribute =
-	__ATTR(spell_delay, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(spell_delay, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * These attributes are i18n related.
  */
 static struct kobj_attribute announcements_attribute =
-	__ATTR(announcements, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(announcements, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute characters_attribute =
-	__ATTR(characters, S_IWUGO|S_IRUGO, chars_chartab_show, chars_chartab_store);
+	__ATTR(characters, S_IWUSR|S_IRUGO, chars_chartab_show, chars_chartab_store);
 static struct kobj_attribute chartab_attribute =
-	__ATTR(chartab, S_IWUGO|S_IRUGO, chars_chartab_show, chars_chartab_store);
+	__ATTR(chartab, S_IWUSR|S_IRUGO, chars_chartab_show, chars_chartab_store);
 static struct kobj_attribute ctl_keys_attribute =
-	__ATTR(ctl_keys, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(ctl_keys, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute colors_attribute =
-	__ATTR(colors, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(colors, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute formatted_attribute =
-	__ATTR(formatted, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(formatted, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute function_names_attribute =
-	__ATTR(function_names, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(function_names, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute key_names_attribute =
-	__ATTR(key_names, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(key_names, S_IWUSR|S_IRUGO, message_show, message_store);
 static struct kobj_attribute states_attribute =
-	__ATTR(states, S_IWUGO|S_IRUGO, message_show, message_store);
+	__ATTR(states, S_IWUSR|S_IRUGO, message_show, message_store);
 
 /*
  * Create groups of attributes so that we can create and destroy them all
diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
index e7dfa434bd96..31f952b9049b 100644
--- a/drivers/staging/speakup/speakup_acntpc.c
+++ b/drivers/staging/speakup/speakup_acntpc.c
@@ -62,22 +62,22 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/acntpc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_acntsa.c b/drivers/staging/speakup/speakup_acntsa.c
index 5079dbd5d7ad..3f2b5698a3d8 100644
--- a/drivers/staging/speakup/speakup_acntsa.c
+++ b/drivers/staging/speakup/speakup_acntsa.c
@@ -47,22 +47,22 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/acntsa.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_apollo.c b/drivers/staging/speakup/speakup_apollo.c
index 38c8c2221e4e..678b263e551c 100644
--- a/drivers/staging/speakup/speakup_apollo.c
+++ b/drivers/staging/speakup/speakup_apollo.c
@@ -53,24 +53,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/apollo.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute lang_attribute =
-	__ATTR(lang, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(lang, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_audptr.c b/drivers/staging/speakup/speakup_audptr.c
index de5b4a5f43b6..362f9747e48d 100644
--- a/drivers/staging/speakup/speakup_audptr.c
+++ b/drivers/staging/speakup/speakup_audptr.c
@@ -49,24 +49,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/audptr.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_bns.c b/drivers/staging/speakup/speakup_bns.c
index 4939e8c7272e..2f070282a85d 100644
--- a/drivers/staging/speakup/speakup_bns.c
+++ b/drivers/staging/speakup/speakup_bns.c
@@ -44,22 +44,22 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/bns.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_decext.c b/drivers/staging/speakup/speakup_decext.c
index b17af9803929..67b7de1d8c75 100644
--- a/drivers/staging/speakup/speakup_decext.c
+++ b/drivers/staging/speakup/speakup_decext.c
@@ -70,24 +70,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/decext.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_decpc.c b/drivers/staging/speakup/speakup_decpc.c
index cfa4bc032358..67678d8888c2 100644
--- a/drivers/staging/speakup/speakup_decpc.c
+++ b/drivers/staging/speakup/speakup_decpc.c
@@ -164,24 +164,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/decpc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_dectlk.c b/drivers/staging/speakup/speakup_dectlk.c
index 1fcae55dabba..af848686be71 100644
--- a/drivers/staging/speakup/speakup_dectlk.c
+++ b/drivers/staging/speakup/speakup_dectlk.c
@@ -70,24 +70,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dectlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_dtlk.c b/drivers/staging/speakup/speakup_dtlk.c
index 5c6c34191e8d..98d1f497e4e0 100644
--- a/drivers/staging/speakup/speakup_dtlk.c
+++ b/drivers/staging/speakup/speakup_dtlk.c
@@ -67,28 +67,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dtlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_dummy.c b/drivers/staging/speakup/speakup_dummy.c
index e19e9994bbb5..362342a194af 100644
--- a/drivers/staging/speakup/speakup_dummy.c
+++ b/drivers/staging/speakup/speakup_dummy.c
@@ -46,22 +46,22 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/dummy.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_keypc.c b/drivers/staging/speakup/speakup_keypc.c
index 9c246d701a95..9d30c1945f92 100644
--- a/drivers/staging/speakup/speakup_keypc.c
+++ b/drivers/staging/speakup/speakup_keypc.c
@@ -59,18 +59,18 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/keypc.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_ltlk.c b/drivers/staging/speakup/speakup_ltlk.c
index c9be6f52c254..d6de72295d33 100644
--- a/drivers/staging/speakup/speakup_ltlk.c
+++ b/drivers/staging/speakup/speakup_ltlk.c
@@ -50,28 +50,28 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/ltlk.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_soft.c b/drivers/staging/speakup/speakup_soft.c
index ee6089502a96..9ed726509261 100644
--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -61,35 +61,35 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/soft.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute freq_attribute =
-	__ATTR(freq, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(freq, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute voice_attribute =
-	__ATTR(voice, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(voice, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 /*
  * We should uncomment the following definition, when we agree on a
  * method of passing a language designation to the software synthesizer.
  * static struct kobj_attribute lang_attribute =
- *	__ATTR(lang, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+ *	__ATTR(lang, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
  */
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_spkout.c b/drivers/staging/speakup/speakup_spkout.c
index 711cf114df83..77f2dc2c3d97 100644
--- a/drivers/staging/speakup/speakup_spkout.c
+++ b/drivers/staging/speakup/speakup_spkout.c
@@ -48,24 +48,24 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/spkout.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute punct_attribute =
-	__ATTR(punct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(punct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
diff --git a/drivers/staging/speakup/speakup_txprt.c b/drivers/staging/speakup/speakup_txprt.c
index 3f0be04df071..dbe84b13772c 100644
--- a/drivers/staging/speakup/speakup_txprt.c
+++ b/drivers/staging/speakup/speakup_txprt.c
@@ -44,22 +44,22 @@ static struct var_t vars[] = {
  * These attributes will appear in /sys/accessibility/speakup/txprt.
  */
 static struct kobj_attribute caps_start_attribute =
-	__ATTR(caps_start, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_start, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute caps_stop_attribute =
-	__ATTR(caps_stop, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(caps_stop, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute pitch_attribute =
-	__ATTR(pitch, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(pitch, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute rate_attribute =
-	__ATTR(rate, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(rate, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute tone_attribute =
-	__ATTR(tone, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(tone, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute vol_attribute =
-	__ATTR(vol, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(vol, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 
 static struct kobj_attribute delay_time_attribute =
 	__ATTR(delay_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute direct_attribute =
-	__ATTR(direct, S_IWUGO|S_IRUGO, spk_var_show, spk_var_store);
+	__ATTR(direct, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute full_time_attribute =
 	__ATTR(full_time, S_IWUSR|S_IRUGO, spk_var_show, spk_var_store);
 static struct kobj_attribute jiffy_delta_attribute =
