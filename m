Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaFPTBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:01:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40647 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaFPTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:01:19 -0400
Date: Mon, 16 Jun 2014 22:01:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 potential strncpy missing null-terminate
Message-ID: <20140616190114.GI5500@mwanda>
References: <1402785707-12383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1402785707-12383-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402785707-12383-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 12:41:47AM +0200, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Generally in the kernel we allow strncpy() if people want to use it.
Let's not start doing sed replacements of these if it doesn't cause a
problem.

Also strncpy() always writes n number of bytes.  If the source string is
not long enough then NUL characters are written.  This is sometimes
important to prevent information leaks so switching to strcpy() can
cause security bugs.

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/ced1401/userspace/use1401.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/ced1401/userspace/use1401.c b/drivers/staging/ced1401/userspace/use1401.c
> index 7b8a222..98d0301 100644
> --- a/drivers/staging/ced1401/userspace/use1401.c
> +++ b/drivers/staging/ced1401/userspace/use1401.c
> @@ -693,7 +693,7 @@ U14API(short) U14DriverName(short hand, char* pBuf, unsigned short wMax)
>      case 3:  pName = "HSS"; break;
>      default: pName = "???"; break;
>      }
> -    strncpy(pBuf, pName, wMax);            // Copy the correct name to return
> +    strlcpy(pBuf, pName, wMax);            /* Copy the correct name to return */
>  
>      return U14ERR_NOERROR;
>  }

No one calls U14DriverName() so just delete this function.

> @@ -1079,7 +1079,7 @@ U14API(short) U14NameOf1401(short hand, char* pBuf, unsigned short wMax)
>      case U14TYPEPOWER3:pName = "Power1401-3"; break;
>      default:           pName = "Unknown";
>      }
> -        strncpy(pBuf, pName, wMax);
> +        strlcpy(pBuf, pName, wMax);
>      }
>      return sErr;
>  }

Same thing.  Just delete the whole function.

> @@ -2891,10 +2891,8 @@ U14API(unsigned int) U14Ld(short hand, const char* vl, const char* str)
>                  ++dwIndex;                      // Keep count of command number, first is 1
>                  szFName[iLoop2]=(char)0;        // null terminate name of command
>  
> -                strncpy(szLastName, szFName, sizeof(szLastName));    // Save for error info
> -                szLastName[sizeof(szLastName)-1] = 0;
> -                strncat(szLastName, szFExt, sizeof(szLastName));     // with extension included
> -                szLastName[sizeof(szLastName)-1] = 0;
> +                strlcpy(szLastName, szFName, sizeof(szLastName));  /* Save for error info */
> +                strlcat(szLastName, szFExt,  sizeof(szLastName));  /* with extension included */
>  
>                  U14SendString(hand, szFName);   // ask if loaded
>                  U14SendString(hand, ";ERR;");   // add err return

Delete again.

regards,
dan carpenter

