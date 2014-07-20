Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaGTGkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 02:40:13 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61205 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaGTGjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 02:39:52 -0400
Message-ID: <53CB6433.8010205@gmail.com>
Date: Sun, 20 Jul 2014 08:39:47 +0200
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, mark.a.allyn@intel.com,
        jayant.mangalampalli@intel.com
CC: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: sep: No else is necessary after a break
 (reported by checkpatch)
References: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>	 <1405791282-28023-3-git-send-email-clabbe.montjoie@gmail.com> <1405792828.14358.110.camel@joe-AO725>
In-Reply-To: <1405792828.14358.110.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/07/2014 20:00, Joe Perches a écrit :
> (Adding Mark Allyn and Jayant Mangalampalli)
> 
> Is this still project still active?

I do not know

> 
> On Sat, 2014-07-19 at 19:34 +0200, LABBE Corentin wrote:
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> ---
>>  drivers/staging/sep/sep_main.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
>> index 177e4b9..1580d95f 100644
>> --- a/drivers/staging/sep/sep_main.c
>> +++ b/drivers/staging/sep/sep_main.c
>> @@ -2881,12 +2881,11 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
>>  				if (is_kva) {
>>  					error = -ENODEV;
>>  					break;
>> -				} else {
>> -					error_temp = copy_to_user(
>> +				}
>> +				error_temp = copy_to_user(
>>  						(void __user *)tail_pt,
>>  						dcb_table_ptr->tail_data,
>>  						dcb_table_ptr->tail_data_size);
>> -				}
>>  				if (error_temp) {
>>  					/* Release the DMA resource */
>>  					error = -EFAULT;
> 
> It'd be probably be better to rewrite the code to unindent
> a level by using continue.  Something like below:
> 
> btw:
> 
> the is_kva test looks very odd and should probably be
> moved outside the loop.
> 
> pt_hold should probably be void * not unsigned long
> as it loses high order bits on x86-32.
> 
> definition:
> 	aligned_u64 out_vr_tail_pt;
> use:
> +			pt_hold = (unsigned long)dcb_table_ptr->
> +				out_vr_tail_pt;
> 

As I said in the introduction email, I have done thoses patch for the Eudyptula challenge,
since I have not the hardware needed by this driver I cannot modify beyond simple style changes without testing

Regards


> ---
>  drivers/staging/sep/sep_main.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
> index 75ca15e..24b4a54 100644
> --- a/drivers/staging/sep/sep_main.c
> +++ b/drivers/staging/sep/sep_main.c
> @@ -2871,26 +2871,23 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
>  		 * Go over each DCB and see if
>  		 * tail pointer must be updated
>  		 */
> -		for (i = 0; i < (*dma_ctx)->nr_dcb_creat;
> -		     i++, dcb_table_ptr++) {
> -			if (dcb_table_ptr->out_vr_tail_pt) {
> -				pt_hold = (unsigned long)dcb_table_ptr->
> -					out_vr_tail_pt;
> -				tail_pt = (void *)pt_hold;
> -				if (is_kva) {
> -					error = -ENODEV;
> -					break;
> -				} else {
> -					error_temp = copy_to_user(
> -						(void __user *)tail_pt,
> -						dcb_table_ptr->tail_data,
> -						dcb_table_ptr->tail_data_size);
> -				}
> -				if (error_temp) {
> -					/* Release the DMA resource */
> -					error = -EFAULT;
> -					break;
> -				}
> +		for (i = 0; i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
> +			if (!dcb_table_ptr->out_vr_tail_pt)
> +				continue;
> +			pt_hold = (unsigned long)dcb_table_ptr->
> +				out_vr_tail_pt;
> +			tail_pt = (void *)pt_hold;
> +			if (is_kva) {
> +				error = -ENODEV;
> +				break;
> +			}
> +			error_temp = copy_to_user((void __user *)tail_pt,
> +						  dcb_table_ptr->tail_data,
> +						  dcb_table_ptr->tail_data_size);
> +			if (error_temp) {
> +				/* Release the DMA resource */
> +				error = -EFAULT;
> +				break;
>  			}
>  		}
>  	}
> 
> 

