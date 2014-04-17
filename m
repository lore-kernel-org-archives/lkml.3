Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaDQUB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:01:59 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:45106 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaDQUBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:01:37 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-a2-5350331ff6b2
Message-id: <5350331C.7010602@samsung.com>
Date: Thu, 17 Apr 2014 14:01:32 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
 <20140416215821.GG26632@htj.dyndns.org>
In-reply-to: <20140416215821.GG26632@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.222]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9hX11544Bgg6/9phbNi9ezWVzeNYfN
	omfDVlaLJwvPMFk8XvGW3eLrTweLX8uPMlpsu7WQxYHDY+esu+weu7btZPJYvOclk8emVZ1s
	HvvnrmH32Pm9gd3j8ya5APYoLpuU1JzMstQifbsErowbx/czF8xUquicuIC5gfGTVBcjB4eE
	gInEpP3pXYycQKaYxIV769m6GLk4hASWMUocv93LBpIQEuhlkvh1zQoisY1R4s/1ZWAJXgEt
	iYcde1hBbBYBVYknny6B2WwC6hKfX+9gh2iWk2haspoZxBYViJB4dXYiC0SvoMSPyffAbBEB
	WYkr0x4ygixgFvjAKHF9Qz9YQljAT+Lzoz3sEJs3MUpcXdgMtoET6OzVb/eAFTELWEusnLSN
	EcKWl9i85i0zxGZliT+XTzFB/KYs8WTKecYJjCKzkCyfhaR9FpL2BYzMqxjFSouTC4qT0lMr
	jPWKE3OLS/PS9ZLzczcxQuKsZgfjva82hxgFOBiVeHgvfPUPFmJNLCuuzD3EKMHBrCTCa6oa
	ECzEm5JYWZValB9fVJqTWnyIkYmDU6oBGO7n/cKy0qMXiDAETyud2/+fteJJCOeHmPKW140t
	WhndnxnTVDSaJ6vev2R2sfnh+tUW/YFdhc+27u1+KjLhdunlrQuWBMUEzLOKLPqeZb/5q19M
	qsK96U1LOifJX7Vd9MtbkXuhyLfJHs5tFt2rlz+6EHNy4sHHl5rOitsey+EQNHycprJbiaU4
	I9FQi7moOBEAoddjIpECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 04/16/2014 03:58 PM, Tejun Heo wrote:
> Hello,

Thanks for the review. A brief description of the use-case first.
Token is intended to be used as a large grain lock and once locked,
it can be held in the locked state for long periods of time.

For instance, application will request video to be captured and the 
media driver digital video function wants to lock a resource that is
shared between analog and digital functions.

>
> On Wed, Apr 09, 2014 at 09:21:08AM -0600, Shuah Khan wrote:
>> +#define TOKEN_DEVRES_FREE	0
>> +#define TOKEN_DEVRES_BUSY	1
>> +
>> +struct token_devres {
>> +	int	status;
>> +	char	id[];
>> +};
>
> Please just do "bool busy" and drop the constants.

Yes bool is fine.

>
>> +struct tkn_match {
>> +	int	status;
>> +	const	char *id;
>> +};
>> +
>> +static void __devm_token_lock(struct device *dev, void *data)
>> +{
>> +	struct token_devres *tptr = data;
>> +
>> +	if (tptr && tptr->status == TOKEN_DEVRES_FREE)
>> +		tptr->status = TOKEN_DEVRES_BUSY;
>
> How can this function be called with NULL @tptr and what why would you
> need to check tptr->status before assigning to it if the value is
> binary anyway?  And how is this supposed to work as locking if the
> outcome doesn't change depending on the current value?

Right. tpr null check is not needed. It is an artifact of re-arranging
the code in devm_token_lock() and __devm_token_lock() and not doing
the proper cleanup.

It can simply be a check to see if token is still free. More on this
below.

if (tptr->status == TOKEN_DEVRES_FREE)
	tptr->status = TOKEN_DEVRES_BUSY;

>
>> +
>> +	return;
>
> No need to return from void function.

Right. I will remove that.

>
>> +static int devm_token_match(struct device *dev, void *res, void *data)
>> +{
>> +	struct token_devres *tkn = res;
>> +	struct tkn_match *mptr = data;
>> +	int rc;
>> +
>> +	if (!tkn || !data) {
>> +		WARN_ON(!tkn || !data);
>> +		return 0;
>> +	}
>
> How would the above be possible?

match function and match_data are optional parameters to devres_find().
find_dr() doesn't check for match_data == null condition. There is a
definite possibility that the match_data could be null. tkn won't be.
Checking tkn is not necessary.

>
>> +
>> +	/* compare the token data and return 1 if it matches */
>> +	if (strcmp(tkn->id, mptr->id) == 0)
>> +			rc = 1;
>> +	else
>> +		rc = 0;
>> +
>> +	return rc;
>
> 	return !strcmp(tkn->id, mptr->id);

Oops! I overlooked cleaning this up after removing debug
messages.

>
>> +/* If token is available, lock it for the caller, If not return -EBUSY */
>> +int devm_token_lock(struct device *dev, const char *id)
>> +{
>> +	struct token_devres *tkn_ptr;
>> +	struct tkn_match tkn;
>> +	int rc = 0;
>> +
>> +	if (!id)
>> +		return -EFAULT;
>
> The function isn't supposed to be called with NULL @id, right?  I
> don't really think it'd be necessary to do the above.
>

Yes that is correct that it shouldn't be called a null id, however,
there is no guarantee that it won't happen. Would you suggest letting
this code fail with null pointer dereference in those rare cases?
It is good way to find places where the interfaces isn't used
correctly. However, it is not a graceful failure.

>> +
>> +	tkn.id = id;
>> +
>> +	tkn_ptr = devres_find(dev, devm_token_release, devm_token_match, &tkn);
>> +	if (tkn_ptr == NULL)
>> +		return -ENODEV;
>
> What guarantees that the lock is not taken by someone else inbetween?

Yes someone else can grab the lock between devres_find() and
devres_update(). It is handled since __devm_token_lock() checks
again if token is still free.

>
> Why is devres_update() even necessary?  You can just embed lock in the
> data part and operate on it, no?

Operating on the lock should be atomic, which is what devres_update()
is doing. It can be simplified as follows by holding devres_lock
in devm_token_lock().

spin_lock_irqsave(&dev->devres_lock, flags);
if (tkn_ptr->status == TOKEN_DEVRES_FREE)
	tkn_ptr->status = TOKEN_DEVRES_BUSY;
spin_unlock_irqrestore(&dev->devres_lock, flags);

Is this in-line with what you have in mind?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
