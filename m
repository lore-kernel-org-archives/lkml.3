Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaBPOZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 09:25:17 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:38803 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaBPOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 09:25:15 -0500
X-Auth-Info: 6k8yg50DqjcmwHVLEeOZciYbZUIsQ3rQ2O+GZKcx57A=
Date: Sun, 16 Feb 2014 15:25:12 +0100
From: Gerhard Sittig <gsi@denx.de>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in message
Message-ID: <20140216142512.GR4524@book.gsilab.sittig.org>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 08:09 +0200, Ivan T. Ivanov wrote:
> 
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> SPI transfer lenght should be a power-of-two multiple
> of eight bits.

Please re-check for "lenght" typos in subjects and commit logs
(code comments appear to be correct already).


The commit message still confuses me.  You don't check that the
length of an SPI transfer has a power-of-two length in bytes.

Instead what the check implements is IIUC
- pad "odd" bits-per-word settings before the check to full 1/2/4
  byte length specs (this is the power-of-two thing)
- the total length of the SPI transfer cannot be empty (which I'd
  consider an optimization, not a violation, and may need a
  separate discussion)
- the total length of the SPI transfer must be such that each
  "word" must be provided within a full 1/2/4 byte entity, with
  padding bits if the bits-per-word is "odd"

Is this a misunderstanding on my side?  A terminology thing?  To
me, the "SPI transfer" is the total payload and may have any
arbitrary length.  What you check for is a constraint on the
transfer's length derived from or based on the "word length"
('word' in SPI context).

So the code may be appropriate, yet the description may need an
update, to not have the next person ask the same questions again.

> @@ -1668,6 +1669,22 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
>  				return -EINVAL;
>  		}
>  
> +		/*
> +		 * SPI transfer length should be multiple of SPI word size
> +		 * where SPI word size should be power-of-two multiple
> +		 */
> +		if (xfer->bits_per_word <= 8)
> +			w_size = 1;
> +		else if (xfer->bits_per_word <= 16)
> +			w_size = 2;
> +		else
> +			w_size = 4;
> +
> +		n_words = xfer->len / w_size;
> +		/* No partial transfers accepted */
> +		if (!n_words || xfer->len % xfer->bits_per_word)
> +			return -EINVAL;
> +
>  		if (xfer->speed_hz && master->min_speed_hz &&
>  		    xfer->speed_hz < master->min_speed_hz)
>  			return -EINVAL;

[ just left the code here for comparison with the above description ]


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
