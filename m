Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3IWAZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 20:25:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37671 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3IWAZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 20:25:20 -0400
Message-ID: <523F8A3C.7010209@zytor.com>
Date: Sun, 22 Sep 2013 17:24:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roy Franz <roy.franz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 10/18] Do proper conversion from UTF-16 to UTF-8
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org> <1379889942-3135-11-git-send-email-roy.franz@linaro.org> <e69e8c38-b195-4797-8ae2-65d69ed9d7aa@email.android.com> <CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA@mail.gmail.com>
In-Reply-To: <CAFECyb_8hqLFajMUfwctVee8e8UvErmu4jmbPguWaeMc-MZuNA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 04:07 PM, Roy Franz wrote:
> On Sun, Sep 22, 2013 at 3:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Sorry this version is broken and doesn't even compile due to remaining options_size references.
> 
> I compiled and tested this series on both x86_64 (using OVMF) and on
> the ARM simulator.  I just doubled checked
> my kernel .config to verify this was not being omitted and I'm pretty
> sure this doesn't have any compilation problems.
> I did make a few changes to get the untested version you sent out to
> compile, but they all seemed to be straightforward typo type fixes.
> I'll gladly address any defects in this patch, but I don't see an
> compilation problems.
> 

Ah yes, I see now... you fixed up the compile problem but did so
incorrectly.

      int load_options_size = image->load_options_size / 2; /* ASCII */

This is a number of UTF-16 chars, the comment is completely wrong;

-              while (*s2 && *s2 != '\n' && options_size <
load_options_size) {
+              while (*s2 && *s2 != '\n' && options_bytes <
load_options_size) {
+                      options_bytes += efi_utf8_bytes(*s2);
                      s2++;
-                      options_size++;
              }
+              options_chars = s2 - options;

You can't compare options_bytes against load_options_size; the latter
being a UTF-16 shortword count.

So the loop really needs to update options_chars in the loop to compare
it against load_options_size:

	while (*s2 && *s2 != '\n' && options_chars < load_options_size) {
		options_bytes += efi_utf8_bytes(*s2++);
		option_chars++;
	}

	-hpa

