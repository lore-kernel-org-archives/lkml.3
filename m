Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaGHTy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:54:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbaGHTy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:54:57 -0400
Date: Tue, 8 Jul 2014 21:54:53 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: stub: Add support for SMBus block commands
Message-ID: <20140708215453.0677d3ed@endymion.delvare>
In-Reply-To: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
References: <1404742983-27303-1-git-send-email-linux@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon,  7 Jul 2014 07:23:03 -0700, Guenter Roeck wrote:
> SMBus block commands are different to I2C block commands since
> the returned data is not normally accessible with byte or word
> commands on other command offsets. Add linked list of 'block'
> commands to support those commands.
> 
> Access mechanism is quite simple: Block commands must be written
> before they can be read. The first write selects the block length.
> Subsequent writes can be partial. Block read commands always return
> the number of bytes selected with the first write.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Make new functionality only available on request via functionality
>     module parameter
>     Add more details about SMBus block mode support to documentation
>     Use correct sizeof() variable in devm_kzalloc
>     Use stub_find_block() only in SMBus block command itself.
>     Store first word of block data in chip->words[].
>     When writing block data and the written data is longer than
>     the first write, bail out with debug message indicating the reason
>     for the error.

Looks good, thanks for the quick update.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

Just one thing I have been thinking about while reviewing the updated
code... You decided to make the first SMBus block write select the
maximum block length, and you always use that for SMBus block reads.
However you accept partial writes. The fact that the order in which
writes are performed has an effect on which writes are accepted is
somewhat unexpected.

Wouldn't it make more sense to accept all SMBus block writes,
regardless of the size (as long as it is within the limits of the SMBus
standard, of course)? Then the only thing left to decide is whether
SMBus block reads use the maximum size or the size of the most recent
SMBus block write.

I suspect this would mimic the behavior of real chips better. What do
you think?

-- 
Jean Delvare
SUSE L3 Support
