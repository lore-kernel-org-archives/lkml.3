Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3KZVHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:07:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab3KZVHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:07:32 -0500
Message-ID: <52950D7B.304@zytor.com>
Date: Tue, 26 Nov 2013 13:07:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: copy_from_user_*() and buffer zeroing
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just started looking into the horribly confused state of buffer
zeroing for the various copy_from_user variants.  This came up after we
did some minor tuning last week.

copy_from_user_inatomic() seems to be documented to not zero the buffer.
 This is definitely *NOT* true on x86-64, although it does seem to be
true on i386 -- on x86-64, we carry along a "zerorest" flag but in all
possible codepaths it will be set to true unless the remaining byte
count is zero anyway.

Furthermore, on at least x86-64, if we do an early bailout, we don't
zero the entire buffer in the case of a hard-coded 10- or 16-byte buffer
(why only those sizes is anybody's guess.)  See lines 71-88 of uaccess_64.h.

I'd like to figure out what is the required and what is the desirable
behavior here, and then fix the code accordingly.

	-hpa
