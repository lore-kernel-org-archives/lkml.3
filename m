Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaFQI6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:58:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45752 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570AbaFQI6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:58:42 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-df-53a0033f120a
Message-id: <53A0031C.5070500@samsung.com>
Date: Tue, 17 Jun 2014 11:58:04 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: dhowells@redhat.com, jwboyer@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1a 1/2] KEYS: validate certificate trust only with
 selected owner key
References: <cover.1402604096.git.d.kasatkin@samsung.com>
 <f49ec580bebe72033a5f4aa160162f393b4ed625.1402604096.git.d.kasatkin@samsung.com>
 <1402919001.2527.11.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1402919001.2527.11.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xy7r2zAuCDRZvFLd41/SbxeLL0jqL
	A++esFjM3vWQxeLyrjlsFh96HrFZfFoxidmB3WPnrLvsHtNOLGPxeHBoM4vH+31X2Tw+b5IL
	YI3isklJzcksSy3St0vgyrjdu4+l4LR0xYrvj1kaGGeIdTFyckgImEjMfjyDCcIWk7hwbz0b
	iC0ksJRR4ttVOwi7kUli1Ur1LkYuIHsWo8TJO7PBGngFtCRefJ7MAmKzCKhKHHhwhBXEZhPQ
	k9jQ/IO9i5GDQ1QgQuLxBSGIckGJH5PvgZWLAIUP7TnFAjKTWaCLUWL2j6lgi4UFYiQuXHnH
	BLHsJKPElUdPWEEGcQq4S8xaUQVSwyygLjFp3iJmCFteYvOat8wQh6pKdK9dywbxjKLE6cnn
	mCcwCs9CsnsWkvZZSNoXMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJlS87GBcfszrE
	KMDBqMTDG3FpfrAQa2JZcWXuIUYJDmYlEV6hV0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjO1f
	pviLtKQ2/7kcr8J1obQ326QxeL9bA5+0jPnBf1yC27fuCwoz8P34K6VQo/bvf+Ul7N2W131/
	OJxV+/Pb+LC3lEaH0aGjR7occl33f7waus10c+Vz7e5d/8Ilfnqfa5GylGL3+rN+P4f0jc3K
	BZGrzojM5luscqDxzosHtUYP3J5tM2N4psRSnJFoqMVcVJwIAJpkBItzAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/14 14:43, Mimi Zohar wrote:
> On Thu, 2014-06-12 at 23:17 +0300, Dmitry Kasatkin wrote:
>> Instead of allowing public keys, with certificates signed by any
>> key on the system trusted keyring, to be added to a trusted keyring,
>> this patch further restricts the certificates to those signed by a
>> particular key on the system keyring.
>>
>> This patch defines a new kernel parameter 'keys_ownerid' to specify
>> owner's key id which must be used for trust validation of certificates.
>>
>> Idea belongs to Mimi Zohar.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  Documentation/kernel-parameters.txt      |  5 +++++
>>  crypto/asymmetric_keys/x509_public_key.c | 23 +++++++++++++++++++++++
>>  2 files changed, 28 insertions(+)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 7116fda..7a810d3 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1434,6 +1434,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			use the HighMem zone if it exists, and the Normal
>>  			zone if it does not.
>>
>> +	keys_ownerid=[KEYS] This parameter identifies a specific key(s) on
>> +			the system trusted keyring to be used for certificate
>> +			trust validation.
>> +			format: id:<keyid>
>> +
>>  	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
>>  			Format: <Controller#>[,poll interval]
>>  			The controller # is the number of the ehci usb debug
>> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
>> index 7a9b386..d46b790 100644
>> --- a/crypto/asymmetric_keys/x509_public_key.c
>> +++ b/crypto/asymmetric_keys/x509_public_key.c
>> @@ -24,6 +24,19 @@
>>  #include "public_key.h"
>>  #include "x509_parser.h"
>>
>> +static char *owner_keyid;
>> +static int __init default_owner_keyid_set(char *str)
>> +{
>> +	if (!str)		/* default system keyring */
>> +		return 1;
>> +
>> +	if (strncmp(str, "id:", 3) == 0)
>> +		owner_keyid = str;	/* owner local key 'id:xxxxxx' */
>> +
>> +	return 1;
>> +}
>> +__setup("keys_ownerid=", default_owner_keyid_set);
>> +
>>  /*
>>   * Find a key in the given keyring by issuer and authority.
>>   */
>> @@ -169,6 +182,16 @@ static int x509_validate_trust(struct x509_certificate *cert,
>>  	if (!trust_keyring)
>>  		return -EOPNOTSUPP;
>>
>> +	if (owner_keyid) {
>> +		/* validate trust only with the owner_keyid if specified */
>> +		/* partial match of keyid according to the asymmetric_type.c */
>> +		int idlen = strlen(owner_keyid) - 3; /* - id: */
>> +		int authlen = strlen(cert->authority);
>> +		char *auth = cert->authority + authlen - idlen;
>> +		if (idlen > authlen || strcasecmp(owner_keyid + 3, auth))
>> +			return -EPERM;
>> +	}
>> +
> We shouldn't hard code the test here, but use the key type's match
> function.  For example, the "KEYS: define an owner trusted keyring" (v4)
> patch defined a key_match() function.  
>
> thanks,

Right.

I addressed this in the following patchset.

Thanks.


>
> Mimi
>
>>  	key = x509_request_asymmetric_key(trust_keyring,
>>  					  cert->issuer, strlen(cert->issuer),
>>  					  cert->authority,
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

