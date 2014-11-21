Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaKVSBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:01:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKVSB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:01:28 -0500
Date: Fri, 21 Nov 2014 12:39:30 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Linux ACPI Mailing List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>
Subject: Re: [PATCH] platform: x86: dell-laptop: Add support for keyboard
 backlight
Message-ID: <20141121203930.GA74402@vmdeb7>
References: <1415967813-7223-1-git-send-email-pali.rohar@gmail.com>
 <20141119183416.GA100640@vmdeb7>
 <201411192141.20190@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411192141.20190@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:41:20PM +0100, Pali Rohár wrote:
> Hello,

Hi Pali,

> 
> I removed other lines so mail is not too long.
> 
> On Wednesday 19 November 2014 19:34:16 Darren Hart wrote:
...
> > > +}
> > > +
> > > +static unsigned int kbd_get_max_level(void)
> > > +{
> > > +	if (kbd_info.levels != 0)
> > > +		return kbd_info.levels;
> > 
> > This test.... does nothing? if it is 0, you still return 0
> > below :-)
> > 
> > > +	if (kbd_mode_levels_count > 0)
> > > +		return kbd_mode_levels_count - 1;
> > > +	return 0;
> > 
> > So the function is:
> > 
> > return kbd_mode_levels_count > 0 ? kbd_mode_levels_count - 1 :
> > kbd_info.levels;
> > 
> > The if blocks are more legible, so that's fine, but the first
> > one doesn't seem to do anything and you can replace the final
> > return with return kbd_info.levels.
> > 
> 
> There are two main way for setting keyboard backlight level. One 
> is setting level register and other one is setting special 
> keyboard mode. And some dell laptops support only first and some 
> only second. So this code choose first available/valid method and 
> then return correct data. I'm not sure if those two methods are 
> only one and also do not know if in future there will be 
> something other. Because of this I use code pattern:
> 
> if (check_method_1) return value_method_1;
> if (check_method_2) return value_method_2;
> ...
> return unsupported;
> 
> Same pattern logic is used in all functions which doing something 
> with keyboard backlight level. (I will not other functions).

Fair enough. Clear, legible, consistent coding is preferable to a few micro
optimizations that the compiler is likely to catch anyway. I withdraw the
comment :-)

> 
> > > +static int kbd_set_state(struct kbd_state *state)
> > > +{
> > > +	int ret;
> > > +
> > > +	get_buffer();
> > > +	buffer->input[0] = 0x2;
> > > +	buffer->input[1] = BIT(state->mode_bit) & 0xFFFF;
> > > +	buffer->input[1] |= (state->triggers & 0xFF) << 16;
> > > +	buffer->input[1] |= (state->timeout_value & 0x3F) << 24;
> > > +	buffer->input[1] |= (state->timeout_unit & 0x3) << 30;
> > > +	buffer->input[2] = state->als_setting & 0xFF;
> > > +	buffer->input[2] |= (state->level & 0xFF) << 16;
> > > +	dell_send_request(buffer, 4, 11);
> > > +	ret = buffer->output[0];
> > > +	release_buffer();
> > > +
> > > +	if (ret)
> > > +		return -EINVAL;
> > 
> > Also, is EINVAL right here and elsewhere? Or did something
> > fail? EXIO?
> > 
> 
> According to Dell documentation, return value is stored in 
> buffer->output[0] and can be:
> 
> 0   Completed successfully
> -1  Completed with error
> -2  Function not supported
> 
> So we can return something other too (not always -EINVAL). Do you 
> have any idea which errno should we return for -1 and -2?

For -1, I should think  -EIO (I/O Error)
For -2, I'd expect -ENXIO (No such device or address)

Cc Rafael, Mika, linux-acpi in case they have a better idea.

> 
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int kbd_set_state_safe(struct kbd_state *state,
> > > struct kbd_state *old) +{
> > > +	int ret;
> > > +
> > > +	ret = kbd_set_state(state);
> > > +	if (ret == 0)
> > > +		return 0;
> > > +
> > > +	if (kbd_set_state(old))
> > > +		pr_err("Setting old previous keyboard state 
> failed\n");
> > 
> > And if we got an error and kbd_set_state(old) doesn't return
> > !0, what's the state of things? Still a failure a presume?
> > 
> 
> In some cases some laptops do not have to support everything. And 
> when I (and Gabriele too) tried to set something unsupported Dell 
> BIOS just resetted all settings to some default values. So this 
> function try to set new state and if it fails then it try to 
> restore previous settings.

OK, that deserves a comment then as the rationale isn't obvious.

> 
> > > +
> > > +	return ret;
> > > +}
> 
> > > +static void kbd_init(void)
> > > +{
> > > +	struct kbd_state state;
> > > +	int ret;
> > > +	int i;
> > > +
> > > +	ret = kbd_get_info(&kbd_info);
> > > +
> > > +	if (ret == 0) {
> > > +
> > 
> > Checking for success, let's invert and avoid the indentation
> > here too.
> > 
> 
> Again this is hard and not possible. This function first process 
> data from kbd_get_info (if does not fail), then process data for 
> kbd_tokens (via function find_token_id) and then set 
> kbd_led_present to true if at least kbd_get_info or kbd_tokens 
> succed.

The goal here is to avoid more than 3 levels of indentations for improved
legibility. Often there are logical inversions and such we can make to
accomplish this. When that fails, we break things up into functions, static
inlines, etc.

For reference:
https://lkml.org/lkml/2007/6/15/449

Which elaborates on CodingStyle Chapter 1: Indentation a bit.

...
> > > +static ssize_t kbd_led_timeout_store(struct device *dev,
> > > +				     struct device_attribute *attr,
> > > +				     const char *buf, size_t count)
> > > +{
> > > +	struct kbd_state state;
> > > +	struct kbd_state new_state;
> > > +	int ret;
> > > +	bool convert;
> > > +	char ch;
> > > +	u8 unit;
> > > +	int value;
> > > +	int i;
> > 
> > Decreasing line lenth please.
> > 
> 
> What do you mean?

This is a nit, but one other maintainers have imposed on me, as a means to
improve legibility. The preference is to declare variables in decreasing line
length, longest to shortest:

struct kbd_state new_state;
struct kbd_state state;
bool convert;
int value;
u8 unit;
char ch;
int ret;
int i;

This is a generalization and sometimes there are good reasons for doing
something else, such as logical groupings for commenting groups, etc. But since
this list appeared mostly random, defaulting to decreasing line length is
preferred.

> 
> > > +	if (convert) {
> > > +		/* NOTE: this switch fall down */
> > 
> > "fall down" ? As in, it intentionally doesn't have breaks?
> > 
> 
> This code convert "value" in "units" to new value in minutes 
> units. So for unit == days it is: 24*60*60... So no breaks.
> 

Right, so the language of the comment just wasn't clear, try:

/* Convert value from seconds to minutes */

> > > +		switch (unit) {
> > > +		case KBD_TIMEOUT_DAYS:
> > > +			value *= 24;
> > > +		case KBD_TIMEOUT_HOURS:
> > > +			value *= 60;
> > > +		case KBD_TIMEOUT_MINUTES:
> > > +			value *= 60;
> > > +			unit = KBD_TIMEOUT_SECONDS;
> > > +	 	}
> > > +

-- 
Darren Hart
Intel Open Source Technology Center
