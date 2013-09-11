Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3IKVMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:12:23 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:50364 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3IKVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:12:21 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 17:12:20 EDT
Date: Wed, 11 Sep 2013 23:01:41 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>, Kirk Reiser <kirk@reisers.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
Message-ID: <20130911210141.GH17803@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Raphael S.Carvalho" <raphael.scarv@gmail.com>,
	William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@reisers.ca>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, speakup@braille.uwo.ca,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raphael S.Carvalho, le Mon 02 Sep 2013 19:20:18 -0300, a écrit :
> Well, there is no need to use strcmp since we can make a test of similar semantic by using the var_id field of param.
> I moved the test into the VAR_NUM:VAR_TIME case since VAR_STRING will never be "voice".
> 
> spk_xlate isn't used anymore (in line 628), then there is no difference between using cp and buf in VAR_STRING case.
> Besides, buf is a const char and those changes remove one uneeded line.
> 
> I created the function spk_reset_default_value because it clarifies the code and allows code reusing.
> 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>

Acked-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

> ---
>  drivers/staging/speakup/kobjects.c |   71 ++++++++++++++++++++----------------
>  1 files changed, 39 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
> index 51bdea3..5c6e77a 100644
> --- a/drivers/staging/speakup/kobjects.c
> +++ b/drivers/staging/speakup/kobjects.c
> @@ -586,6 +586,25 @@ ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
>  EXPORT_SYMBOL_GPL(spk_var_show);
>  
>  /*
> + * Used to reset either default_pitch or default_vol.
> + */
> +static inline void spk_reset_default_value(char *header_name,
> +					int *synth_default_value, int idx)
> +{
> +	struct st_var_header *param;
> +
> +	if (synth && synth_default_value) {
> +		param = spk_var_header_by_name(header_name);
> +		if (param)  {
> +			spk_set_num_var(synth_default_value[idx],
> +					param, E_NEW_DEFAULT);
> +			spk_set_num_var(0, param, E_DEFAULT);
> +			pr_info("%s reset to default value\n", param->name);
> +		}
> +	}
> +}
> +
> +/*
>   * This function is called when a user echos a value to one of the
>   * variable parameters.
>   */
> @@ -624,56 +643,44 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
>  		if (ret == -ERANGE) {
>  			var_data = param->data;
>  			pr_warn("value for %s out of range, expect %d to %d\n",
> -				attr->attr.name,
> +				param->name,
>  				var_data->u.n.low, var_data->u.n.high);
>  		}
> +
> +	       /*
> +		* If voice was just changed, we might need to reset our default
> +		* pitch and volume.
> +		*/
> +		if (param->var_id == VOICE) {
> +			spk_reset_default_value("pitch", synth->default_pitch,
> +				value);
> +			spk_reset_default_value("vol", synth->default_vol,
> +				value);
> +		}
>  		break;
>  	case VAR_STRING:
> -		len = strlen(buf);
> -		if ((len >= 1) && (buf[len - 1] == '\n'))
> +		len = strlen(cp);
> +		if ((len >= 1) && (cp[len - 1] == '\n'))
>  			--len;
> -		if ((len >= 2) && (buf[0] == '"') && (buf[len - 1] == '"')) {
> -			++buf;
> +		if ((len >= 2) && (cp[0] == '"') && (cp[len - 1] == '"')) {
> +			++cp;
>  			len -= 2;
>  		}
> -		cp = (char *) buf;
>  		cp[len] = '\0';
> -		ret = spk_set_string_var(buf, param, len);
> +		ret = spk_set_string_var(cp, param, len);
>  		if (ret == -E2BIG)
>  			pr_warn("value too long for %s\n",
> -					attr->attr.name);
> +					param->name);
>  		break;
>  	default:
>  		pr_warn("%s unknown type %d\n",
>  			param->name, (int)param->var_type);
>  	break;
> -	}
> -	/*
> -	 * If voice was just changed, we might need to reset our default
> -	 * pitch and volume.
> -	 */
> -	if (strcmp(attr->attr.name, "voice") == 0) {
> -		if (synth && synth->default_pitch) {
> -			param = spk_var_header_by_name("pitch");
> -			if (param)  {
> -				spk_set_num_var(synth->default_pitch[value],
> -						param, E_NEW_DEFAULT);
> -				spk_set_num_var(0, param, E_DEFAULT);
> -			}
> -		}
> -		if (synth && synth->default_vol) {
> -			param = spk_var_header_by_name("vol");
> -			if (param)  {
> -				spk_set_num_var(synth->default_vol[value],
> -						param, E_NEW_DEFAULT);
> -				spk_set_num_var(0, param, E_DEFAULT);
> -			}
> -		}
> -	}
> +	}
>  	spin_unlock_irqrestore(&speakup_info.spinlock, flags);
>  
>  	if (ret == -ERESTART)
> -		pr_info("%s reset to default value\n", attr->attr.name);
> +		pr_info("%s reset to default value\n", param->name);
>  	return count;
>  }
>  EXPORT_SYMBOL_GPL(spk_var_store);
> -- 
> 1.7.2.5
> 

-- 
Samuel
AUTHOR
     FvwmM4 is the result of a random  bit  mutation  on  a  hard
     disk,  presumably  a  result  of  a  cosmic-ray or some such
     thing.
(extrait de la page de man de FvwmM4)
