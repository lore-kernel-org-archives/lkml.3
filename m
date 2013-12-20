Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3LTJNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:13:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab3LTJNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:13:05 -0500
Date: Fri, 20 Dec 2013 12:12:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>, klmckinney1 <klmckinney1@gmail.com>,
        tulinizer <tulinizer@gmail.com>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/staging/bcm: Integer overflow
Message-ID: <20131220091255.GR5443@mwanda>
References: <1387523596-29543-1-git-send-email-fanwlexca@gmail.com>
 <20131220081633.GL28413@mwanda>
 <CAPLUJPaJiiaervQTPoYES3C9mvTx2gGGXizrEMN3GA6jY=b0Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPLUJPaJiiaervQTPoYES3C9mvTx2gGGXizrEMN3GA6jY=b0Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 04:51:45PM +0800, Wenliang Fan wrote:
> Thanks for your advice.
> But the variable 'psFlash2xReadWrite->offset' in '
> *drivers/staging/bcm/nvm.c*:validateFlash2xReadWrite()' is also comes from
> user space, which would cause an integer overflow in the following line:
> 
> if ((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <=
> uiSectEndOffset)
> 
> in '*drivers/staging/bcm/**nvm.c*: validateFlash2xReadWrite()',
> and another integer overflow in the following line:
> 
> 
> ReadOffset = ReadOffset + ReadBytes; (or WriteOffset = WriteOffset +
> WriteBytes;)
> 
> in '*drivers/staging/bcm/**Bcmchar.c*: bcm_char_ioctl()'.
> 

Alright, fine.  But the new check is messy.  Do it like this:

	/* these are user controlled and can lead to integer overflows */
	if (psFlash2xReadWrite->offset > uiSectEndOffset)
		return false;
	if (uiNumOfBytes > uiSectEndOffset)
		return false;
	if (uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes > uiSectEndOffset)
		return false;

	return true;

That way each step is simpler to understand.  People are too fond of
compound conditions... *grumble*.

regards,
dan carpenter

