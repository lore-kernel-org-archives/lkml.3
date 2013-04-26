Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3DZUOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 16:14:12 -0400
Received: from science.horizon.com ([71.41.210.146]:49906 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757635Ab3DZUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 16:14:12 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 16:14:11 EDT
Date: 26 Apr 2013 16:07:30 -0400
Message-ID: <20130426200730.9729.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: keescook@chromium.org
Subject: Re: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a logic simplification, the following gets rid of one variable
that's simply not needed.  (And adds a "static" declaration that seems
to be appropriate):

static bool largest_ram_region(unsigned long *start, unsigned long *size)
{
	int i;

	*size = 0;
	for (i = 0; i < real_mode->e820_entries; i++) {
		struct e820entry *entry = &real_mode->e820_map[i];

		if (entry->type != E820_RAM)
			continue;

		if (entry->size > *size) {
			*size = entry->size;
			*start = entry->addr;
		}
	}
	return *size != 0;
}

but I might instead do it as:

struct e820_entry const *largest_ram_region()
{
	struct e820_entry const *rc = NULL;
	unsigned long size = 0;
	int i;

	for (i = 0; i < real_mode->e820_entries; i++) {
		struct e820entry const *entry = &real_mode->e820_map[i];

		if (entry->type == E820_RAM && entry->size > size) {
			size = entry->size;
			rc = entry;
		}
	}
	return rc;
}

... with appropriate adjustments to the caller.  Anyway,
your choice.
